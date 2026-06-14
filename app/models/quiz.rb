class Quiz < ApplicationRecord
  belongs_to :lesson
  has_one :course, through: :lesson
  has_many :questions, -> { order(order_number: :asc) }, dependent: :destroy
  has_many :quiz_attempts, dependent: :destroy

  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
  validates :passing_score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def passing_score
    super || 70
  end

  # Corrige uma submissão. answers = { question_id => option_id }
  # Retorna { score:, passed:, correct:, total: }
  def grade(answers)
    total = questions.count
    return { score: 0, passed: false, correct: 0, total: 0 } if total.zero?

    correct = questions.count do |question|
      chosen = answers[question.id.to_s] || answers[question.id]
      chosen.present? && question.correct_option_id == chosen.to_i
    end

    score = (correct.to_f / total * 100).round
    { score: score, passed: score >= passing_score, correct: correct, total: total }
  end
end
