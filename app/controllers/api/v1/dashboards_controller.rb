module Api
  module V1
    class DashboardsController < ApplicationController
      include Authenticable
      skip_before_action :verify_authenticity_token
      before_action :authorize_member

      # GET /api/v1/dashboard
      def show
        progresses = @current_user.course_progresses.includes(:course)

        render json: {
          member: {
            id: @current_user.id,
            name: @current_user.name,
            email: @current_user.email,
            subscription_status: @current_user.subscription_status
          },
          stats: {
            courses_enrolled: progresses.size,
            courses_completed: progresses.count { |p| p.percentage >= 100 },
            lessons_completed: progresses.sum(&:completed_lessons),
            achievements: @current_user.user_achievements.count,
            certificates: @current_user.certificates.count
          },
          courses_in_progress: progresses
            .reject { |p| p.percentage >= 100 }
            .sort_by { |p| p.last_accessed_at || p.updated_at }
            .reverse
            .first(5)
            .map { |p| serialize_progress(p) },
          recent_activities: @current_user.activities.recent.limit(5).map { |a| serialize_activity(a) }
        }, status: :ok
      end

      private

      def serialize_progress(progress)
        {
          course_id: progress.course_id,
          title: progress.course.title,
          percentage: progress.percentage.to_f,
          completed_lessons: progress.completed_lessons,
          total_lessons: progress.course.total_lessons,
          last_accessed_at: progress.last_accessed_at&.utc&.iso8601
        }
      end

      def serialize_activity(activity)
        {
          id: activity.id,
          type: activity.activity_type,
          title: activity.title,
          occurred_at: activity.occurred_at&.utc&.iso8601
        }
      end

      def authorize_member
        unless @current_user&.role == 'member'
          render json: { error: 'Access denied. Members only.' }, status: :forbidden
        end
      end
    end
  end
end
