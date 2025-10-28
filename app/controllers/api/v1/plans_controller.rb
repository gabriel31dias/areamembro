module Api
  module V1
    class PlansController < ApplicationController
      skip_before_action :verify_authenticity_token

      def index
        plans = Plan.active.order(price: :asc)
        
        plans_data = plans.map do |plan|
          {
            id: plan.id,
            name: plan.name,
            description: plan.description,
            price: plan.price,
            duration_days: plan.duration_days,
            features: plan.features
          }
        end

        render json: { plans: plans_data }, status: :ok
      end
    end
  end
end
