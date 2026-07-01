module Panel
  class DashboardController < BaseController
    def index
      members = current_panel_user.members.where(role: 'member')
      member_ids = members.select(:id)

      # Cursos do produtor
      @total_courses = current_panel_user.courses.count
      @active_courses = current_panel_user.courses.where(active: true).count

      # Membros do produtor
      @total_users = members.count
      @active_members = members.where(status: 'active').count
      @subscribers = members.where(subscription_status: 'subscriber').count

      # Vendas dos membros do produtor
      sales = Sale.where(user_id: member_ids)
      @total_revenue = sales.completed.sum(:amount)
      @pending_sales = sales.pending.count
      @completed_sales = sales.completed.count
      @recent_sales = sales.includes(:user, :plan).completed.order(created_at: :desc).limit(5)

      # Taxa de conversão
      @conversion_rate = @total_users > 0 ? ((@subscribers.to_f / @total_users) * 100).round(1) : 0

      # Cursos recentes do produtor
      @recent_courses = current_panel_user.courses.order(created_at: :desc).limit(4)
    end
  end
end
