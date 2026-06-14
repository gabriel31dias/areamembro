class Certificate < ApplicationRecord
  belongs_to :user
  belongs_to :course

  validates :user_id, uniqueness: { scope: :course_id }
  validates :code, presence: true, uniqueness: true

  before_validation :generate_code, on: :create
  before_validation :set_issued_at, on: :create

  private

  def generate_code
    self.code ||= "CERT-#{SecureRandom.hex(6).upcase}"
  end

  def set_issued_at
    self.issued_at ||= Time.current
  end
end
