module Api
  module V1
    class LessonsController < ApplicationController
      include Authenticable
      skip_before_action :verify_authenticity_token
      before_action :authorize_member

      def index
        course = Course.find_by(id: params[:course_id])
        
        unless course
          render json: { error: 'Course not found' }, status: :not_found
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

        progress = LessonProgress.find_or_initialize_by(
          user_id: @current_user.id,
          lesson_id: lesson.id
        )

        progress.watched_seconds = params[:watched_seconds] if params[:watched_seconds]
        progress.completed = params[:completed] if params.key?(:completed)

        if progress.save
          # Atualizar progresso do curso
          update_course_progress(lesson.course_id)

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
        total_lessons = course.lessons.count
        completed_lessons = LessonProgress.joins(:lesson)
                                          .where(user_id: @current_user.id, completed: true)
                                          .where(lessons: { course_id: course_id })
                                          .count

        course_progress = CourseProgress.find_or_initialize_by(
          user_id: @current_user.id,
          course_id: course_id
        )
        
        course_progress.completed_lessons = completed_lessons
        course_progress.last_accessed_at = Time.current
        course_progress.save
      end
    end
  end
end
