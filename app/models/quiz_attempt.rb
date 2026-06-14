class QuizAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :quiz

  before_validation :set_submitted_at, on: :create

  scope :passed, -> { where(passed: true) }

  private

  def set_submitted_at
    self.submitted_at ||= Time.current
  end
end
