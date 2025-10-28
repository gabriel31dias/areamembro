class CourseProgress < ApplicationRecord
  belongs_to :user
  belongs_to :course

  validates :user_id, uniqueness: { scope: :course_id }
  validates :completed_lessons, numericality: { greater_than_or_equal_to: 0 }

  before_save :calculate_percentage

  private

  def calculate_percentage
    if course.total_lessons > 0
      self.percentage = (completed_lessons.to_f / course.total_lessons * 100).round(2)
    else
      self.percentage = 0.0
    end
  end
end
