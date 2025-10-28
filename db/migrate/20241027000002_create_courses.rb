class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.string :title, null: false
      t.text :description
      t.integer :total_lessons, default: 0
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :courses, :active
  end
end
