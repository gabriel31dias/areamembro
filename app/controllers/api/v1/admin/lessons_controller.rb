module Api
  module V1
    module Admin
      class LessonsController < ApplicationController
        include Authenticable
        skip_before_action :verify_authenticity_token
        before_action :authorize_admin

        def create
          course = Course.find_by(id: params[:course_id])
          
          unless course
            render json: { error: 'Course not found' }, status: :not_found
            return
          end

          lesson = course.lessons.new(lesson_params)

          if lesson.save
            # Atualizar total_lessons do curso
            course.update(total_lessons: course.lessons.count)

            render json: {
              message: 'Lesson created successfully',
              lesson: lesson_response(lesson)
            }, status: :created
          else
            render json: { errors: lesson.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          lesson = Lesson.find_by(id: params[:id])
          
          unless lesson
            render json: { error: 'Lesson not found' }, status: :not_found
            return
          end

          if lesson.update(lesson_params)
            render json: {
              message: 'Lesson updated successfully',
              lesson: lesson_response(lesson)
            }, status: :ok
          else
            render json: { errors: lesson.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          lesson = Lesson.find_by(id: params[:id])
          
          unless lesson
            render json: { error: 'Lesson not found' }, status: :not_found
            return
          end

          course = lesson.course

          if lesson.destroy
            # Atualizar total_lessons do curso
            course.update(total_lessons: course.lessons.count)

            render json: { message: 'Lesson deleted successfully' }, status: :ok
          else
            render json: { errors: lesson.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def authorize_admin
          unless @current_user&.role == 'admin'
            render json: { error: 'Access denied. Admins only.' }, status: :forbidden
          end
        end

        def lesson_params
          params.permit(:title, :description, :video_url, :order_number, :duration_minutes)
        end

        def lesson_response(lesson)
          {
            id: lesson.id,
            course_id: lesson.course_id,
            title: lesson.title,
            description: lesson.description,
            video_url: lesson.video_url,
            order_number: lesson.order_number,
            duration_minutes: lesson.duration_minutes
          }
        end
      end
    end
  end
end
