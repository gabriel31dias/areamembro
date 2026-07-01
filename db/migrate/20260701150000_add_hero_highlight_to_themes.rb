class AddHeroHighlightToThemes < ActiveRecord::Migration[8.1]
  def change
    add_column :themes, :hero_highlight, :string
  end
end
