class Question < ApplicationRecord
  belongs_to :quiz
  has_many :question_options, dependent: :destroy
  alias_method :options, :question_options

  accepts_nested_attributes_for :question_options, allow_destroy: true, reject_if: :all_blank

  validates :statement, presence: true

  scope :ordered, -> { order(order_number: :asc) }

  # Índice (posição) da alternativa correta, vindo do form via radio.
  attr_accessor :correct_index
  before_validation :assign_correct_option

  def assign_correct_option
    return if correct_index.nil? || correct_index == ""
    question_options.each_with_index do |opt, idx|
      opt.correct = (idx.to_s == correct_index.to_s)
    end
  end

  def correct_option
    question_options.find_by(correct: true)
  end

  def correct_option_id
    correct_option&.id
  end
end
