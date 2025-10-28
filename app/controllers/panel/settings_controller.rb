module Panel
  class SettingsController < BaseController
    def index
      @user = current_panel_user
    end

    def update
      @user = current_panel_user
      
      if @user.update(settings_params)
        redirect_to panel_courses_path, notice: 'Configurações salvas com sucesso!'
      else
        render :index, status: :unprocessable_entity
      end
    end

    private

    def settings_params
      params.require(:user).permit(:api_key, :api_secret)
    end
  end
end
