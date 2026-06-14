module Api
  module V1
    class ThemesController < ApplicationController
      include Authenticable
      skip_before_action :verify_authenticity_token
      before_action :authorize_member

      # GET /api/v1/theme
      # Retorna as cores configuradas pelo produtor (owner) do member.
      # Se o produtor não configurou nenhum tema, devolve as cores padrão.
      def show
        theme = @current_user.owner&.theme || Theme.new

        logo_url = theme.logo.attached? ? rails_blob_url(theme.logo) : nil

        render json: {
          theme: theme.colors.merge(
            member_area_title: theme.member_area_title,
            primary_description: theme.primary_description,
            secondary_description: theme.secondary_description,
            logo_url: logo_url
          )
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
