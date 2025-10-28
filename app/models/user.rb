class User < ApplicationRecord
  has_secure_password
  
  has_many :course_progresses, dependent: :destroy
  has_many :courses, through: :course_progresses
  has_many :sales, dependent: :destroy
  has_many :user_plans, dependent: :destroy
  has_many :plans, through: :user_plans
  
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w[admin user member] }
  validates :status, inclusion: { in: %w[active blocked] }
  validates :subscription_status, inclusion: { in: %w[free subscriber] }

  scope :active, -> { where(status: 'active') }
  scope :blocked, -> { where(status: 'blocked') }
  scope :subscribers, -> { where(subscription_status: 'subscriber') }
  scope :members, -> { where(role: 'member') }

  def block!
    update(status: 'blocked', blocked_at: Time.current)
  end

  def unblock!
    update(status: 'active', blocked_at: nil)
  end

  def make_subscriber!
    update(subscription_status: 'subscriber')
  end

  def current_plan
    user_plans.active.first&.plan
  end

  def has_active_plan?
    user_plans.active.exists?
  end
end
