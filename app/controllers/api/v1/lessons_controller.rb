module Api
  module V1
    class LessonsController < ApplicationController
      include Authenticable
      skip_before_action :verify_authenticity_token
      before_action :authorize_member

      def index
        course = Course.find_by(id: params[:course_id], user_id: @current_user.owner_id)

        unless course
          render json: { error: 'Course not found' }, status: :not_found
          return
        end

        unless course.accessible_by?(@current_user)
          render json: {
            error: 'Você não tem um plano compatível com este curso.',
            has_access: false,
            plans: course.plans.map { |plan| { id: plan.id, name: plan.name } }
          }, status: :forbidden
          return
        end

        lessons = course.lessons.ordered
        
        lessons_with_progress = lessons.map do |lesson|
          progress = LessonProgress.find_by(user_id: @current_user.id, lesson_id: lesson.id)
          
          {
            id: lesson.id,
            title: lesson.title,
            description: lesson.description,
            video_url: lesson.video_url,
            video_file_url: lesson.video.attached? ? rails_blob_url(lesson.video) : nil,
            has_video: lesson.has_video?,
            has_quiz: lesson.quiz.present?,
            quiz_id: lesson.quiz&.id,
            order_number: lesson.order_number,
            duration_minutes: lesson.duration_minutes,
            progress: {
              completed: progress&.completed || false,
              watched_seconds: progress&.watched_seconds || 0,
              completed_at: progress&.completed_at
            }
          }
        end

        render json: { 
          course_id: course.id,
          course_title: course.title,
          lessons: lessons_with_progress 
        }, status: :ok
      end

      def update_progress
        lesson = Lesson.find_by(id: params[:id])

        unless lesson
          render json: { error: 'Lesson not found' }, status: :not_found
          return
        end

        unless lesson.course&.accessible_by?(@current_user)
          render json: { error: 'Você não tem um plano compatível com este curso.', has_access: false }, status: :forbidden
          return
        end

        progress = LessonProgress.find_or_initialize_by(
          user_id: @current_user.id,
          lesson_id: lesson.id
        )

        was_completed = progress.completed

        progress.watched_seconds = params[:watched_seconds] if params[:watched_seconds]
        progress.completed = params[:completed] if params.key?(:completed)

        if progress.save
          # Atualizar progresso do curso (também registra course_started / course_completed)
          update_course_progress(lesson.course_id)
          track_lesson_activity(lesson, progress, was_completed)
          Achievement.evaluate_lessons!(@current_user)

          render json: {
            message: 'Lesson progress updated successfully',
            progress: {
              lesson_id: lesson.id,
              completed: progress.completed,
              watched_seconds: progress.watched_seconds,
              completed_at: progress.completed_at
            }
          }, status: :ok
        else
          render json: { errors: progress.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def authorize_member
        unless @current_user&.role == 'member'
          render json: { error: 'Access denied. Members only.' }, status: :forbidden
        end
      end

      def update_course_progress(course_id)
        course = Course.find(course_id)
        completed_lessons = LessonProgress.joins(:lesson)
                                          .where(user_id: @current_user.id, completed: true)
                                          .where(lessons: { course_id: course_id })
                                          .count

        course_progress = CourseProgress.find_or_initialize_by(
          user_id: @current_user.id,
          course_id: course_id
        )

        first_access = course_progress.new_record?
        was_complete = course_progress.percentage.to_f >= 100

        course_progress.completed_lessons = completed_lessons
        course_progress.last_accessed_at = Time.current
        course_progress.save

        # course_started: primeira vez que o member toca no curso
        if first_access
          Activity.track(@current_user, :course_started,
            title: 'Curso iniciado',
            description: "Você iniciou #{course.title}",
            metadata: { course_id: course.id, course_title: course.title })
        end

        # course_completed: ao atingir 100% pela primeira vez
        if !was_complete && course_progress.percentage.to_f >= 100
          Activity.track(@current_user, :course_completed,
            title: 'Curso concluído',
            description: "Você concluiu o curso #{course.title}",
            metadata: { course_id: course.id, course_title: course.title })
          issue_certificate(course)
        end
      end

      # Emite o certificado do curso (1ª vez) e dispara a conquista "Diplomado"
      def issue_certificate(course)
        return if Certificate.exists?(user_id: @current_user.id, course_id: course.id)

        certificate = Certificate.create!(user: @current_user, course: course)

        Activity.track(@current_user, :certificate_issued,
          title: 'Certificado emitido',
          description: "Você recebeu o certificado de #{course.title}",
          metadata: { course_id: course.id, course_title: course.title, code: certificate.code })

        Achievement.unlock(@current_user, :graduate)
      end

      # Registra lesson_completed (quando conclui agora) ou lesson_progress
      def track_lesson_activity(lesson, progress, was_completed)
        if progress.completed && !was_completed
          Activity.track(@current_user, :lesson_completed,
            title: 'Aula concluída',
            description: "Você concluiu a aula #{lesson.title}",
            metadata: {
              course_id: lesson.course_id,
              course_title: lesson.course.title,
              lesson_id: lesson.id,
              lesson_title: lesson.title
            })
        elsif params[:watched_seconds].present?
          minutes = (progress.watched_seconds.to_i / 60.0).round
          total_seconds = lesson.duration_minutes.to_i * 60
          percentage = total_seconds.positive? ? (progress.watched_seconds.to_f / total_seconds * 100).round : nil

          Activity.track(@current_user, :lesson_progress,
            title: 'Progresso atualizado',
            description: "Você assistiu #{minutes} minutos da aula #{lesson.title}",
            metadata: {
              course_id: lesson.course_id,
              lesson_id: lesson.id,
              watched_seconds: progress.watched_seconds,
              percentage: percentage
            })
        end
      end
    end
  end
end
