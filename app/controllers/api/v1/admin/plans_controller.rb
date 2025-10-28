module Api
  module V1
    module Admin
      class PlansController < ApplicationController
        include Authenticable
        skip_before_action :verify_authenticity_token
        before_action :authorize_admin

        def index
          plans = Plan.all.order(created_at: :desc)
          
          plans_data = plans.map { |plan| plan_response(plan) }
          
          render json: { plans: plans_data }, status: :ok
        end

        def show
          plan = Plan.find_by(id: params[:id])
          
          unless plan
            render json: { error: 'Plan not found' }, status: :not_found
            return
          end

          render json: { plan: plan_detail_response(plan) }, status: :ok
        end

        def create
          plan = Plan.new(plan_params)
          
          if plan.save
            render json: {
              message: 'Plan created successfully',
              plan: plan_response(plan)
            }, status: :created
          else
            render json: { errors: plan.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def update
          plan = Plan.find_by(id: params[:id])
          
          unless plan
            render json: { error: 'Plan not found' }, status: :not_found
            return
          end

          if plan.update(plan_params)
            render json: {
              message: 'Plan updated successfully',
              plan: plan_response(plan)
            }, status: :ok
          else
            render json: { errors: plan.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          plan = Plan.find_by(id: params[:id])
          
          unless plan
            render json: { error: 'Plan not found' }, status: :not_found
            return
          end

          if plan.user_plans.active.exists?
            render json: { error: 'Cannot delete plan with active subscriptions' }, status: :forbidden
            return
          end

          if plan.destroy
            render json: { message: 'Plan deleted successfully' }, status: :ok
          else
            render json: { errors: plan.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def authorize_admin
          unless @current_user&.role == 'admin'
            render json: { error: 'Access denied. Admins only.' }, status: :forbidden
          end
        end

        def plan_params
          params.permit(:name, :description, :price, :duration_days, :active, features: [])
        end

        def plan_response(plan)
          {
            id: plan.id,
            name: plan.name,
            description: plan.description,
            price: plan.price,
            duration_days: plan.duration_days,
            active: plan.active,
            features: plan.features,
            created_at: plan.created_at
          }
        end

        def plan_detail_response(plan)
          {
            id: plan.id,
            name: plan.name,
            description: plan.description,
            price: plan.price,
            duration_days: plan.duration_days,
            active: plan.active,
            features: plan.features,
            created_at: plan.created_at,
            stats: {
              active_subscriptions: plan.user_plans.active.count,
              total_subscriptions: plan.user_plans.count,
              total_revenue: plan.sales.completed.sum(:amount)
            }
          }
        end
      end
    end
  end
end
