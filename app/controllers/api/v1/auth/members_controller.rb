module Api
  module V1
    module Auth
      class MembersController < ApplicationController
        skip_before_action :verify_authenticity_token

        def login
          user = User.find_by(email: params[:email], role: 'member')
          
          if user&.authenticate(params[:password])
            token = JwtService.encode(user_id: user.id, role: user.role)
            render json: { 
              token: token, 
              user: { 
                id: user.id, 
                email: user.email, 
                role: user.role 
              } 
            }, status: :ok
          else
            render json: { error: 'Invalid credentials' }, status: :unauthorized
          end
        end

        def signup
          user = User.new(
            email: params[:email],
            password: params[:password],
            password_confirmation: params[:password_confirmation],
            role: 'member'
          )

          if user.save
            token = JwtService.encode(user_id: user.id, role: user.role)
            render json: { 
              token: token, 
              user: { 
                id: user.id, 
                email: user.email, 
                role: user.role 
              } 
            }, status: :created
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
