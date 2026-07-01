module Api
  module V1
    # Estatísticas públicas da área de membros de um produtor (para a tela de login).
    # GET /api/v1/member_area_stats?id=123
    class MemberAreaStatsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def show
        owner = User.find_by(id: params[:id])
        courses = owner ? owner.courses.where(active: true) : Course.none

        render json: {
          stats: {
            courses: courses.count,
            lessons: Lesson.where(course_id: courses.select(:id)).count,
            members: owner ? owner.members.where(role: 'member').count : 0
          }
        }, status: :ok
      end
    end
  end
end
