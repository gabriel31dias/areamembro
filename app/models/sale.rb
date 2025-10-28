class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :plan, optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[pending completed cancelled] }

  scope :completed, -> { where(status: 'completed') }
  scope :pending, -> { where(status: 'pending') }

  after_update :activate_user_plan, if: :saved_change_to_status?

  private

  def activate_user_plan
    if status == 'completed' && user.role == 'member'
      user.make_subscriber!
      
      if plan.present?
        UserPlan.create!(
          user: user,
          plan: plan,
          status: 'active'
        )
      end
    end
  end
end
