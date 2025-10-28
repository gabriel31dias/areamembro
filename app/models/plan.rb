class Plan < ApplicationRecord
  has_many :sales
  has_many :user_plans
  has_many :users, through: :user_plans

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :duration_days, numericality: { greater_than: 0 }

  scope :active, -> { where(active: true) }
end
