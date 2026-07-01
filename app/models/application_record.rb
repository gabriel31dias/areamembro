class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # SQLite não gera UUID no banco; geramos aqui antes de inserir.
  before_create :assign_uuid_primary_key

  private

  def assign_uuid_primary_key
    return unless self.class.primary_key == "id"
    self.id = SecureRandom.uuid if id.blank?
  end
end
