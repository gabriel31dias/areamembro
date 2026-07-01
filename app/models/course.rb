class Course < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :photo
  has_many :course_progresses, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :quizzes, through: :lessons
  has_many :certificates, dependent: :destroy
  has_many :members, through: :course_progresses, source: :user
  has_many :course_plans, dependent: :destroy
  has_many :plans, through: :course_plans

  accepts_nested_attributes_for :lessons, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
  validates :total_lessons, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }

  # Um membro tem acesso ao curso se ele não estiver vinculado a nenhum plano
  # (aberto a todos) ou se o membro possuir um plano ativo entre os planos do curso.
  def accessible_by?(member)
    required_plan_ids = plans.map(&:id)
    return true if required_plan_ids.empty?

    (required_plan_ids & member.user_plans.active.pluck(:plan_id)).any?
  end

  def photo_url
    if photo.attached?
      Rails.application.routes.url_helpers.rails_blob_url(photo, only_path: true)
    else
      nil
    end
  end
end
