class UserPlan < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  validates :user_id, uniqueness: { scope: :plan_id, conditions: -> { where(status: 'active') } }
  validates :status, inclusion: { in: %w[active expired cancelled] }

  scope :active, -> { where(status: 'active').where('expires_at > ?', Time.current) }
  scope :expired, -> { where('expires_at <= ?', Time.current) }

  before_create :set_expiration_date

  def active?
    status == 'active' && expires_at > Time.current
  end

  def expire!
    update(status: 'expired')
  end

  private

  def set_expiration_date
    self.expires_at = Time.current + plan.duration_days.days if expires_at.nil?
  end
end
