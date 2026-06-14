class AddDescriptionsToThemes < ActiveRecord::Migration[8.1]
  def change
    add_column :themes, :primary_description, :text
    add_column :themes, :secondary_description, :text
  end
end
