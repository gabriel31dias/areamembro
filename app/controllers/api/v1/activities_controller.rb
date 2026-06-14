module Api
  module V1
    class ActivitiesController < ApplicationController
      include Authenticable
      skip_before_action :verify_authenticity_token
      before_action :authorize_member

      # GET /api/v1/activities?limit=10
      def index
        limit = params.fetch(:limit, 20).to_i
        limit = 20 if limit <= 0
        limit = 100 if limit > 100

        activities = @current_user.activities.recent.limit(limit)

        render json: {
          activities: activities.map { |activity| serialize(activity) }
        }, status: :ok
      end

      private

      def serialize(activity)
        {
          id: activity.id,
          type: activity.activity_type,
          title: activity.title,
          description: activity.description,
          occurred_at: activity.occurred_at&.utc&.iso8601,
          metadata: activity.metadata || {}
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
