module Admin
  class DashboardController < BaseController
    def index
      @total_users = User.count
      @total_members = User.members.count
      @active_subscribers = User.subscribers.count
      @total_sales = Sale.completed.sum(:amount)
      @pending_sales = Sale.pending.count
      @total_courses = Course.count
      
      @recent_sales = Sale.includes(:user, :plan).order(created_at: :desc).limit(5)
      @recent_users = User.order(created_at: :desc).limit(5)
    end
  end
end
