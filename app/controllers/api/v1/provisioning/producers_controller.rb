require "open-uri"

module Api
  module V1
    module Provisioning
      # Endpoint público para provisionar uma conta de produtor (role 'user'),
      # já com email/senha, credenciais de API e tema completo da área de membros.
      # Autorizado por uma chave estática enviada no header X-Api-Key.
      class ProducersController < ApplicationController
        skip_before_action :verify_authenticity_token
        before_action :authorize_provisioning_key

        # Mesmos limites de logo do model Theme
        ALLOWED_LOGO_TYPES = %w[image/png image/jpeg image/webp image/svg+xml].freeze
        MAX_LOGO_BYTES = 5.megabytes

        # POST /api/v1/provisioning/producers
        def create
          user  = User.new(user_params.merge(role: "user"))
          theme = user.build_theme(theme_attributes)

          attach_logo(theme) if logo_url.present?

          ActiveRecord::Base.transaction do
            user.save!
            theme.save!
          end

          token = JwtService.encode(user_id: user.id, role: user.role)

          render json: {
            token: token,
            producer: producer_payload(user),
            theme: theme_payload(theme)
          }, status: :created
        rescue ActiveRecord::RecordInvalid => e
          render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
        rescue LogoDownloadError => e
          render json: { errors: [e.message] }, status: :unprocessable_entity
        end

        # GET /api/v1/provisioning/producers?cnpj_ou_cpf=...
        # Lista todas as empresas (produtores) cadastradas com o CNPJ/CPF informado.
        def index
          cnpj = params[:cnpj_ou_cpf].to_s.strip

          if cnpj.blank?
            return render json: { errors: ["Informe o parâmetro cnpj_ou_cpf"] }, status: :unprocessable_entity
          end

          producers = User.where(role: "user", cnpj_ou_cpf: cnpj).order(:created_at)

          render json: {
            cnpj_ou_cpf: cnpj,
            count: producers.size,
            producers: producers.map { |user| producer_payload(user) }
          }, status: :ok
        end

        private

        def producer_payload(user)
          {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
            cnpj_ou_cpf: user.cnpj_ou_cpf
          }
        end

        class LogoDownloadError < StandardError; end

        def authorize_provisioning_key
          expected = Rails.application.credentials.provisioning_api_key ||
                     ENV["PROVISIONING_API_KEY"] ||
                     "0030015529"

          provided = request.headers["X-Api-Key"]

          unless provided.present? && ActiveSupport::SecurityUtils.secure_compare(provided, expected)
            render json: { error: "Invalid API key" }, status: :unauthorized
          end
        end

        def user_params
          params.permit(:email, :password, :name, :api_key, :api_secret, :cnpj_ou_cpf)
        end

        # Só repassa os campos do tema que vieram no payload; ausentes caem no Theme::DEFAULTS.
        def theme_attributes
          return {} unless params[:theme].is_a?(ActionController::Parameters)

          params.require(:theme).permit(
            :member_area_title, :primary_description, :secondary_description,
            *Theme::COLOR_FIELDS
          ).to_h.symbolize_keys
        end

        def logo_url
          params.dig(:theme, :logo_url)
        end

        def attach_logo(theme)
          downloaded = URI.parse(logo_url).open(read_timeout: 10)
          content_type = downloaded.content_type

          unless ALLOWED_LOGO_TYPES.include?(content_type)
            raise LogoDownloadError, "Logo deve ser uma imagem (PNG, JPG, WEBP ou SVG)"
          end

          if downloaded.size > MAX_LOGO_BYTES
            raise LogoDownloadError, "Logo deve ter no máximo 5MB"
          end

          theme.logo.attach(
            io: downloaded,
            filename: File.basename(URI.parse(logo_url).path).presence || "logo",
            content_type: content_type
          )
        rescue OpenURI::HTTPError, SocketError, Errno::ECONNREFUSED, URI::InvalidURIError, Net::OpenTimeout, Net::ReadTimeout
          raise LogoDownloadError, "Não foi possível baixar o logo a partir da URL informada"
        end

        def theme_payload(theme)
          logo = theme.logo.attached? ? rails_blob_url(theme.logo, only_path: true) : nil

          theme.colors.merge(
            member_area_title: theme.member_area_title,
            primary_description: theme.primary_description,
            secondary_description: theme.secondary_description,
            logo_url: logo
          )
        end
      end
    end
  end
end
