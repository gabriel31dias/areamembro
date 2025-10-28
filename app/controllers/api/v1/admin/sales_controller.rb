module Api
  module V1
    module Admin
      class SalesController < ApplicationController
        include Authenticable
        skip_before_action :verify_authenticity_token
        before_action :authorize_admin

        def index
          sales = Sale.includes(:user).order(created_at: :desc)
          
          if params[:status].present?
            sales = sales.where(status: params[:status])
          end

          if params[:user_id].present?
            sales = sales.where(user_id: params[:user_id])
          end

          sales_data = sales.map { |sale| sale_response(sale) }

          render json: {
            sales: sales_data,
            summary: {
              total_completed: Sale.completed.sum(:amount),
              total_pending: Sale.pending.sum(:amount),
              count_completed: Sale.completed.count,
              count_pending: Sale.pending.count
            }
          }, status: :ok
        end

        def create
          user = User.find_by(id: params[:user_id])
          
          unless user
            render json: { error: 'User not found' }, status: :not_found
            return
          end

          sale = user.sales.new(sale_params)

          if sale.save
            render json: {
              message: 'Sale created successfully',
              sale: sale_response(sale)
            }, status: :created
          else
            render json: { errors: sale.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          sale = Sale.find_by(id: params[:id])
          
          unless sale
            render json: { error: 'Sale not found' }, status: :not_found
            return
          end

          if sale.update(sale_update_params)
            render json: {
              message: 'Sale updated successfully',
              sale: sale_response(sale)
            }, status: :ok
          else
            render json: { errors: sale.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          sale = Sale.find_by(id: params[:id])
          
          unless sale
            render json: { error: 'Sale not found' }, status: :not_found
            return
          end

          if sale.destroy
            render json: { message: 'Sale deleted successfully' }, status: :ok
          else
            render json: { errors: sale.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def authorize_admin
          unless @current_user&.role == 'admin'
            render json: { error: 'Access denied. Admins only.' }, status: :forbidden
          end
        end

        def sale_params
          params.permit(:amount, :payment_method, :status, :notes)
        end

        def sale_update_params
          params.permit(:amount, :payment_method, :status, :notes)
        end

        def sale_response(sale)
          {
            id: sale.id,
            user: {
              id: sale.user.id,
              name: sale.user.name,
              email: sale.user.email,
              subscription_status: sale.user.subscription_status
            },
            amount: sale.amount,
            payment_method: sale.payment_method,
            status: sale.status,
            notes: sale.notes,
            created_at: sale.created_at,
            updated_at: sale.updated_at
          }
        end
      end
    end
  end
end
