class AddHeroTextsToThemes < ActiveRecord::Migration[8.1]
  def change
    add_column :themes, :hero_title, :string
    add_column :themes, :hero_subtitle, :string
  end
end
