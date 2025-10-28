module Panel
  class MembersController < BaseController
    before_action :set_member, only: [:show, :edit, :update, :destroy]

    def index
      @members = current_panel_user.members.where(role: 'member').order(created_at: :desc)
      
      @members = @members.where("name LIKE ? OR email LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
      @members = @members.where(status: params[:status]) if params[:status].present?
      @members = @members.where(subscription_status: params[:subscription]) if params[:subscription].present?
      
      @members = @members.page(params[:page]).per(12)
    end

    def show
      @sales = @member.sales.includes(:plan).order(created_at: :desc).limit(10)
      @course_progresses = @member.course_progresses.includes(:course).order(updated_at: :desc).limit(5)
    end

    def new
      @member = User.new(role: 'member')
    end

    def create
      @member = current_panel_user.members.build(member_params.merge(role: 'member'))
      
      if @member.save
        redirect_to panel_members_path, notice: 'Membro criado com sucesso!'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      update_params = member_params
      # Remove password fields if blank
      if update_params[:password].blank?
        update_params.delete(:password)
        update_params.delete(:password_confirmation)
      end
      
      if @member.update(update_params)
        redirect_to panel_member_path(@member), notice: 'Membro atualizado com sucesso!'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @member.destroy
      redirect_to panel_members_path, notice: 'Membro deletado com sucesso!'
    end

    private

    def set_member
      @member = current_panel_user.members.find(params[:id])
    end

    def member_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :status, :subscription_status)
    end
  end
end
