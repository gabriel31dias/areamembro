class Sale < ApplicationRecord
  belongs_to :user

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[pending completed cancelled] }

  scope :completed, -> { where(status: 'completed') }
  scope :pending, -> { where(status: 'pending') }

  after_update :update_user_subscription, if: :saved_change_to_status?

  private

  def update_user_subscription
    if status == 'completed' && user.role == 'member'
      user.make_subscriber!
    end
  end
end
