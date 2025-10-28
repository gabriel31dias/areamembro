module Api
  module V1
    module Admin
      class CoursesController < ApplicationController
        include Authenticable
        skip_before_action :verify_authenticity_token
        before_action :authorize_admin

        def create
          course = Course.new(course_params)
          
          if params[:photo].present?
            course.photo.attach(params[:photo])
          end

          if course.save
            render json: {
              message: 'Course created successfully',
              course: course_response(course)
            }, status: :created
          else
            render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          course = Course.find_by(id: params[:id])
          
          unless course
            render json: { error: 'Course not found' }, status: :not_found
            return
          end

          if params[:photo].present?
            course.photo.attach(params[:photo])
          end

          if course.update(course_params)
            render json: {
              message: 'Course updated successfully',
              course: course_response(course)
            }, status: :ok
          else
            render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          course = Course.find_by(id: params[:id])
          
          unless course
            render json: { error: 'Course not found' }, status: :not_found
            return
          end

          if course.destroy
            render json: { message: 'Course deleted successfully' }, status: :ok
          else
            render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def authorize_admin
          unless @current_user&.role == 'admin'
            render json: { error: 'Access denied. Admins only.' }, status: :forbidden
          end
        end

        def course_params
          params.permit(:title, :description, :total_lessons, :active)
        end

        def course_response(course)
          {
            id: course.id,
            title: course.title,
            description: course.description,
            photo_url: course.photo_url,
            total_lessons: course.total_lessons,
            active: course.active
          }
        end
      end
    end
  end
end
