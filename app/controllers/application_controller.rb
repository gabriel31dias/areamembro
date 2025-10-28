class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_admin_user, :admin_logged_in?

  private

  def current_admin_user
    @current_admin_user ||= User.find_by(id: session[:admin_user_id]) if session[:admin_user_id]
  end

  def admin_logged_in?
    current_admin_user.present? && current_admin_user.role == 'admin'
  end

  def require_admin_login
    unless admin_logged_in?
      redirect_to admin_login_path, alert: 'Você precisa estar logado como admin'
    end
  end
end
