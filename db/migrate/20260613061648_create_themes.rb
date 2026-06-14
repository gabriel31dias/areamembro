class CreateThemes < ActiveRecord::Migration[8.1]
  def change
    create_table :themes do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :primary_color, default: "#00d4ff"
      t.string :secondary_color, default: "#0066ff"
      t.string :background_color, default: "#f8fafc"

      t.timestamps
    end
  end
end
