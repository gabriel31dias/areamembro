module Panel
  class SessionsController < ApplicationController
    layout 'panel_auth'

    def new
    end

    def create
      user = User.find_by(email: params[:email])
      
      if user&.authenticate(params[:password]) && user.role == 'user'
        session[:panel_user_id] = user.id
        redirect_to panel_courses_path, notice: 'Login realizado com sucesso!'
      else
        flash.now[:alert] = 'Email ou senha inválidos'
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session[:panel_user_id] = nil
      redirect_to panel_login_path, notice: 'Logout realizado com sucesso!'
    end
  end
end
