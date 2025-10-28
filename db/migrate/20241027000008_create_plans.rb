class CreatePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :duration_days, null: false
      t.boolean :active, default: true
      t.json :features

      t.timestamps
    end

    add_index :plans, :active
  end
end
