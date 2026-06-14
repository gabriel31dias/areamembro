module Api
  module V1
    class AchievementsController < ApplicationController
      include Authenticable
      skip_before_action :verify_authenticity_token
      before_action :authorize_member

      # GET /api/v1/achievements
      # Lista todas as conquistas do catálogo, marcando as desbloqueadas pelo member.
      def index
        unlocked = @current_user.user_achievements.index_by(&:achievement_key)

        achievements = Achievement::CATALOG.map do |key, info|
          ua = unlocked[key]
          {
            key: key,
            name: info[:name],
            description: info[:description],
            icon: info[:icon],
            unlocked: ua.present?,
            unlocked_at: ua&.unlocked_at&.utc&.iso8601
          }
        end

        render json: {
          achievements: achievements,
          unlocked_count: unlocked.size,
          total: Achievement::CATALOG.size
        }, status: :ok
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
