class User < ApplicationRecord
  has_secure_password validations: false
  
  belongs_to :owner, class_name: 'User', optional: true
  has_many :members, class_name: 'User', foreign_key: 'owner_id', dependent: :nullify
  
  has_many :courses, dependent: :destroy
  has_many :course_progresses, dependent: :destroy
  has_many :enrolled_courses, through: :course_progresses, source: :course
  has_many :plans, dependent: :destroy
  has_many :ebooks, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :user_plans, dependent: :destroy
  has_many :subscribed_plans, through: :user_plans, source: :plan
  
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w[admin user member] }
  validates :status, inclusion: { in: %w[active blocked] }
  validates :subscription_status, inclusion: { in: %w[free subscriber] }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

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
