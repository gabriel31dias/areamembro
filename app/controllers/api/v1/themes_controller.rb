module Api
  module V1
    class ThemesController < ApplicationController
      include Authenticable
      skip_before_action :verify_authenticity_token
      before_action :authorize_member, unless: -> { params[:id].present? }

      # GET /api/v1/theme            -> tema do produtor (owner) do member autenticado (via token)
      # GET /api/v1/theme?id=123     -> tema da área de membro 123, sem autenticação
      # Se não houver tema configurado, devolve as cores padrão.
      def show
        owner = params[:id].present? ? User.find_by(id: params[:id]) : @current_user.owner
        theme = owner&.theme || Theme.new

        logo_url = theme.logo.attached? ? rails_blob_url(theme.logo) : nil

        render json: {
          theme: theme.colors.merge(
            member_area_title: theme.member_area_title,
            primary_description: theme.primary_description,
            secondary_description: theme.secondary_description,
            login_title: theme.login_title,
            login_subtitle: theme.login_subtitle,
            hero_title: theme.hero_title,
            hero_highlight: theme.hero_highlight,
            hero_subtitle: theme.hero_subtitle,
            logo_url: logo_url
          )
        }, status: :ok
      end

      private

      # Com ?id presente a rota é pública (não exige token).
      def authenticate_request
        return if params[:id].present?
        super
      end

      def authorize_member
        unless @current_user&.role == 'member'
          render json: { error: 'Access denied. Members only.' }, status: :forbidden
        end
      end
    end
  end
end
