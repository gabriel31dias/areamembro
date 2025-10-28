module Api
  module V1
    module Admin
      class UsersController < ApplicationController
        include Authenticable
        skip_before_action :verify_authenticity_token
        before_action :authorize_admin

        def index
          users = User.all.order(created_at: :desc)
          
          if params[:role].present?
            users = users.where(role: params[:role])
          end

          if params[:status].present?
            users = users.where(status: params[:status])
          end

          users_data = users.map { |user| user_response(user) }
          
          render json: { users: users_data }, status: :ok
        end

        def show
          user = User.find_by(id: params[:id])
          
          unless user
            render json: { error: 'User not found' }, status: :not_found
            return
          end

          render json: { user: user_detail_response(user) }, status: :ok
        end

        def create
          user = User.new(user_params)
          
          if user.save
            render json: {
              message: 'User created successfully',
              user: user_response(user)
            }, status: :created
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          user = User.find_by(id: params[:id])
          
          unless user
            render json: { error: 'User not found' }, status: :not_found
            return
          end

          if user.update(user_update_params)
            render json: {
              message: 'User updated successfully',
              user: user_response(user)
            }, status: :ok
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          user = User.find_by(id: params[:id])
          
          unless user
            render json: { error: 'User not found' }, status: :not_found
            return
          end

          if user.id == @current_user.id
            render json: { error: 'Cannot delete yourself' }, status: :forbidden
            return
          end

          if user.destroy
            render json: { message: 'User deleted successfully' }, status: :ok
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def block
          user = User.find_by(id: params[:id])
          
          unless user
            render json: { error: 'User not found' }, status: :not_found
            return
          end

          if user.id == @current_user.id
            render json: { error: 'Cannot block yourself' }, status: :forbidden
            return
          end

          if user.block!
            render json: {
              message: 'User blocked successfully',
              user: user_response(user)
            }, status: :ok
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def unblock
          user = User.find_by(id: params[:id])
          
          unless user
            render json: { error: 'User not found' }, status: :not_found
            return
          end

          if user.unblock!
            render json: {
              message: 'User unblocked successfully',
              user: user_response(user)
            }, status: :ok
          else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def sales
          user = User.find_by(id: params[:id])
          
          unless user
            render json: { error: 'User not found' }, status: :not_found
            return
          end

          sales = user.sales.order(created_at: :desc)
          sales_data = sales.map { |sale| sale_response(sale) }

          render json: {
            user_id: user.id,
            user_email: user.email,
            total_sales: sales.completed.sum(:amount),
            sales: sales_data
          }, status: :ok
        end

        private

        def authorize_admin
          unless @current_user&.role == 'admin'
            render json: { error: 'Access denied. Admins only.' }, status: :forbidden
          end
        end

        def user_params
          params.permit(:email, :password, :password_confirmation, :role, :name)
        end

        def user_update_params
          params.permit(:email, :name, :role, :subscription_status)
        end

        def user_response(user)
          {
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role,
            status: user.status,
            subscription_status: user.subscription_status,
            blocked_at: user.blocked_at,
            created_at: user.created_at
          }
        end

        def user_detail_response(user)
          {
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role,
            status: user.status,
            subscription_status: user.subscription_status,
            blocked_at: user.blocked_at,
            created_at: user.created_at,
            stats: {
              total_courses: user.course_progresses.count,
              completed_courses: user.course_progresses.where('percentage = 100').count,
              total_sales: user.sales.completed.sum(:amount),
              sales_count: user.sales.completed.count
            }
          }
        end

        def sale_response(sale)
          {
            id: sale.id,
            amount: sale.amount,
            payment_method: sale.payment_method,
            status: sale.status,
            notes: sale.notes,
            created_at: sale.created_at
          }
        end
      end
    end
  end
end
