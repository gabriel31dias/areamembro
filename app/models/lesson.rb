class Lesson < ApplicationRecord
  belongs_to :course
  has_one :quiz, dependent: :destroy
  has_one_attached :video
  has_many :lesson_progresses, dependent: :destroy
  has_many :users, through: :lesson_progresses

  validates :title, presence: true
  validates :order_number, numericality: { greater_than_or_equal_to: 0 }
  validates :duration_minutes, numericality: { greater_than_or_equal_to: 0 }
  validate :acceptable_video

  scope :ordered, -> { order(order_number: :asc) }

  # Indica se a aula possui algum vídeo (upload ou URL externa)
  def has_video?
    video.attached? || video_url.present?
  end

  # Caminho para reproduzir o vídeo enviado por upload
  def video_file_url
    return nil unless video.attached?
    Rails.application.routes.url_helpers.rails_blob_url(video, only_path: true)
  end

  private

  def acceptable_video
    return unless video.attached?

    unless video.content_type.in?(%w[video/mp4 video/webm video/ogg video/quicktime])
      errors.add(:video, 'deve ser um arquivo de vídeo (MP4, WEBM, OGG ou MOV)')
    end

    if video.byte_size > 500.megabytes
      errors.add(:video, 'deve ter no máximo 500MB')
    end
  end
end
