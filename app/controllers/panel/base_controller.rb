module Panel
  class BaseController < ApplicationController
    layout 'panel'
    before_action :require_user_login

    private

    def current_panel_user
      @current_panel_user ||= User.find_by(id: session[:panel_user_id]) if session[:panel_user_id]
    end

    def user_logged_in?
      current_panel_user.present? && current_panel_user.role == 'user'
    end

    def require_user_login
      unless user_logged_in?
        redirect_to panel_login_path, alert: 'Você precisa estar logado'
      end
    end

    helper_method :current_panel_user, :user_logged_in?
  end
end
