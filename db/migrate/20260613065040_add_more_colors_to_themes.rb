class AddMoreColorsToThemes < ActiveRecord::Migration[8.1]
  def change
    add_column :themes, :surface_color, :string, default: "#ffffff"
    add_column :themes, :text_color, :string, default: "#0a0e27"
    add_column :themes, :muted_text_color, :string, default: "#64748b"
  end
end
