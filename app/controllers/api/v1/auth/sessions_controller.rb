module Api
  module V1
    module Auth
      class SessionsController < ApplicationController
        include Authenticable
        skip_before_action :verify_authenticity_token

        # GET /api/v1/auth/me
        # Retorna os dados do usuário autenticado a partir do token JWT (qualquer role)
        def me
          render json: {
            user: {
              id: @current_user.id,
              name: @current_user.name,
              email: @current_user.email,
              role: @current_user.role,
              status: @current_user.status,
              subscription_status: @current_user.subscription_status,
              blocked_at: @current_user.blocked_at,
              created_at: @current_user.created_at
            }
          }, status: :ok
        end
      end
    end
  end
end
