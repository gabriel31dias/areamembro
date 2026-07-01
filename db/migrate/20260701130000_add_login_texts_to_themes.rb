class AddLoginTextsToThemes < ActiveRecord::Migration[8.1]
  def change
    add_column :themes, :login_title, :string
    add_column :themes, :login_subtitle, :string
  end
end
