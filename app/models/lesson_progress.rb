class LessonProgress < ApplicationRecord
  belongs_to :user
  belongs_to :lesson

  validates :user_id, uniqueness: { scope: :lesson_id }
  validates :watched_seconds, numericality: { greater_than_or_equal_to: 0 }

  before_save :set_completed_at

  private

  def set_completed_at
    if completed && completed_at.nil?
      self.completed_at = Time.current
    elsif !completed
      self.completed_at = nil
    end
  end
end
