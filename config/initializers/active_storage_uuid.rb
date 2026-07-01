# Active Storage usa PK uuid (via config.generators), mas o SQLite não gera o
# UUID. ActiveStorage::Record não herda de ApplicationRecord, então geramos aqui.
ActiveSupport.on_load(:active_storage_record) do
  before_create do
    self.id = SecureRandom.uuid if has_attribute?("id") && id.blank?
  end
end
