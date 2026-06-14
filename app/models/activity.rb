class Activity < ApplicationRecord
  belongs_to :user

  TYPES = %w[
    course_started
    lesson_started
    lesson_progress
    lesson_completed
    course_completed
    certificate_issued
    profile_updated
    login
    subscription_started
    subscription_cancelled
    achievement_unlocked
  ].freeze

  validates :activity_type, presence: true, inclusion: { in: TYPES }

  before_validation :set_occurred_at, on: :create

  scope :recent, -> { order(occurred_at: :desc, id: :desc) }

  # Registra uma atividade do usuário.
  # Ex: Activity.track(user, :lesson_completed, title: "...", description: "...", metadata: { ... })
  def self.track(user, activity_type, title:, description: nil, metadata: {}, occurred_at: Time.current)
    create(
      user: user,
      activity_type: activity_type.to_s,
      title: title,
      description: description,
      metadata: metadata || {},
      occurred_at: occurred_at
    )
  end

  private

  def set_occurred_at
    self.occurred_at ||= Time.current
  end
end
