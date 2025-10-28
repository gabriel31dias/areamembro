module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:show, :edit, :update, :destroy, :block, :unblock]

    def index
      @users = User.all.order(created_at: :desc)
      
      # Filtros
      @users = @users.where(role: params[:role]) if params[:role].present?
      @users = @users.where(status: params[:status]) if params[:status].present?
      
      # Busca por nome ou email
      if params[:search].present?
        search_term = "%#{params[:search]}%"
        @users = @users.where("name LIKE ? OR email LIKE ?", search_term, search_term)
      end
      
      @users = @users.page(params[:page]).per(12)
    end

    def show
      @sales = @user.sales.includes(:plan).order(created_at: :desc)
      @course_progresses = @user.course_progresses.includes(:course).order(updated_at: :desc).limit(10)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      
      if @user.save
        redirect_to admin_user_path(@user), notice: 'Usuário criado com sucesso!'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: 'Usuário atualizado com sucesso!'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @user.id == current_admin_user.id
        redirect_to admin_users_path, alert: 'Você não pode deletar a si mesmo!'
        return
      end

      @user.destroy
      redirect_to admin_users_path, notice: 'Usuário deletado com sucesso!'
    end

    def block
      if @user.id == current_admin_user.id
        redirect_to admin_user_path(@user), alert: 'Você não pode bloquear a si mesmo!'
        return
      end

      @user.block!
      redirect_to admin_user_path(@user), notice: 'Usuário bloqueado com sucesso!'
    end

    def unblock
      @user.unblock!
      redirect_to admin_user_path(@user), notice: 'Usuário desbloqueado com sucesso!'
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :status, :subscription_status, :api_key, :api_secret)
    end
  end
end
