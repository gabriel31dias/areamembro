class Course < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :photo
  has_many :course_progresses, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :members, through: :course_progresses, source: :user

  accepts_nested_attributes_for :lessons, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
  validates :total_lessons, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }

  def photo_url
    if photo.attached?
      Rails.application.routes.url_helpers.rails_blob_url(photo, only_path: true)
    else
      nil
    end
  end
end
