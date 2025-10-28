module Api
  module V1
    class CoursesController < ApplicationController
      include Authenticable
      skip_before_action :verify_authenticity_token
      before_action :authorize_member, only: [:index, :update_progress]

      def index
        courses = Course.active.order(created_at: :desc)
        
        courses_with_progress = courses.map do |course|
          progress = CourseProgress.find_by(user_id: @current_user.id, course_id: course.id)
          
          {
            id: course.id,
            title: course.title,
            description: course.description,
            photo_url: course.photo_url,
            total_lessons: course.total_lessons,
            progress: {
              completed_lessons: progress&.completed_lessons || 0,
              percentage: progress&.percentage || 0.0,
              last_accessed_at: progress&.last_accessed_at
            }
          }
        end

        render json: { courses: courses_with_progress }, status: :ok
      end

      def update_progress
        course = Course.find_by(id: params[:id])
        
        unless course
          render json: { error: 'Course not found' }, status: :not_found
          return
        end

        progress = CourseProgress.find_or_initialize_by(
          user_id: @current_user.id,
          course_id: course.id
        )

        progress.completed_lessons = params[:completed_lessons] if params[:completed_lessons]
        progress.last_accessed_at = Time.current

        if progress.save
          render json: {
            message: 'Progress updated successfully',
            progress: {
              course_id: course.id,
              completed_lessons: progress.completed_lessons,
              percentage: progress.percentage,
              last_accessed_at: progress.last_accessed_at
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
    end
  end
end
