class Ebook < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :cover
  has_one_attached :file

  validates :title, presence: true
  validates :pages, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }

  def cover_url
    if cover.attached?
      Rails.application.routes.url_helpers.rails_blob_url(cover, only_path: true)
    else
      nil
    end
  end

  def file_url
    if file.attached?
      Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true)
    else
      nil
    end
  end
end
