class Lesson < ApplicationRecord
  belongs_to :course
  has_many :lesson_progresses, dependent: :destroy
  has_many :users, through: :lesson_progresses

  validates :title, presence: true
  validates :order_number, numericality: { greater_than_or_equal_to: 0 }
  validates :duration_minutes, numericality: { greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(order_number: :asc) }
end
