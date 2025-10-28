class Plan < ApplicationRecord
  belongs_to :user, optional: true
  has_many :sales
  has_many :user_plans
  has_many :subscribers, through: :user_plans, source: :user

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :duration_days, numericality: { greater_than: 0 }

  scope :active, -> { where(active: true) }
end
