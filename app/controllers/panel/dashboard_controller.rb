module Panel
  class DashboardController < BaseController
    def index
      # Cursos
      @total_courses = Course.count
      @active_courses = Course.where(active: true).count
      
      # Usuários
      @total_users = User.count
      @active_members = User.where(role: 'member', status: 'active').count
      @subscribers = User.where(subscription_status: 'subscriber').count
      
      # Vendas
      @total_revenue = Sale.completed.sum(:amount)
      @pending_sales = Sale.pending.count
      @completed_sales = Sale.completed.count
      @recent_sales = Sale.includes(:user, :plan).completed.order(created_at: :desc).limit(5)
      
      # Taxa de conversão
      @conversion_rate = @total_users > 0 ? ((@subscribers.to_f / @total_users) * 100).round(1) : 0
      
      # Cursos recentes
      @recent_courses = Course.order(created_at: :desc).limit(4)
    end
  end
end
