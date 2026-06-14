module Panel
  class SettingsController < BaseController
    def index
      @user = current_panel_user
      @theme = @user.theme || @user.build_theme
    end

    def update
      @user = current_panel_user
      @theme = @user.theme || @user.build_theme

      if params[:theme].present?
        if @theme.update(theme_params)
          @theme.logo.purge if params.dig(:theme, :remove_logo) == '1'
          redirect_to panel_settings_path, notice: 'Tema da área de membros atualizado!'
        else
          render :index, status: :unprocessable_entity
        end
      else
        if @user.update(settings_params)
          redirect_to panel_settings_path, notice: 'Configurações salvas com sucesso!'
        else
          render :index, status: :unprocessable_entity
        end
      end
    end

    private

    def settings_params
      params.require(:user).permit(:api_key, :api_secret)
    end

    def theme_params
      params.require(:theme).permit(
        :member_area_title, :primary_description, :secondary_description,
        :primary_color, :secondary_color, :background_color,
        :surface_color, :text_color, :muted_text_color, :logo
      )
    end
  end
end
