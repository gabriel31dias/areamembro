class UserAchievement < ApplicationRecord
  belongs_to :user

  validates :achievement_key, presence: true,
                              uniqueness: { scope: :user_id },
                              inclusion: { in: -> (_) { Achievement::KEYS } }

  before_validation :set_unlocked_at, on: :create

  private

  def set_unlocked_at
    self.unlocked_at ||= Time.current
  end
end
