module Admin
  class SessionsController < ApplicationController
    layout 'admin_auth'

    def new
    end

    def create
      user = User.find_by(email: params[:email])
      
      if user&.authenticate(params[:password]) && user.role == 'admin'
        session[:admin_user_id] = user.id
        redirect_to admin_dashboard_path, notice: 'Login realizado com sucesso!'
      else
        flash.now[:alert] = 'Email ou senha inválidos'
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session[:admin_user_id] = nil
      redirect_to admin_login_path, notice: 'Logout realizado com sucesso!'
    end
  end
end
