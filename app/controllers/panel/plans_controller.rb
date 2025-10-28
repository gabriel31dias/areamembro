module Panel
  class PlansController < BaseController
    before_action :set_plan, only: [:show, :edit, :update, :destroy]

    def index
      @plans = Plan.all.order(price: :asc)
      
      if params[:search].present?
        @plans = @plans.where("name LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
      end
      
      if params[:active].present?
        @plans = @plans.where(active: params[:active] == 'true')
      end
      
      @plans = @plans.page(params[:page]).per(12)
    end

    def show
      @sales = @plan.sales.includes(:user).order(created_at: :desc).limit(10)
      @subscribers = @plan.user_plans.active.includes(:user).limit(10)
    end

    def new
      @plan = Plan.new
    end

    def create
      @plan = Plan.new(plan_params)
      
      if @plan.save
        redirect_to panel_plans_path, notice: 'Plano criado com sucesso!'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @plan.update(plan_params)
        redirect_to panel_plan_path(@plan), notice: 'Plano atualizado com sucesso!'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @plan.destroy
      redirect_to panel_plans_path, notice: 'Plano deletado com sucesso!'
    end

    private

    def set_plan
      @plan = Plan.find(params[:id])
    end

    def plan_params
      params.require(:plan).permit(:name, :description, :price, :duration_days, :active)
    end
  end
end
