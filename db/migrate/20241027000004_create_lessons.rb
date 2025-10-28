class CreateLessons < ActiveRecord::Migration[8.1]
  def change
    create_table :lessons do |t|
      t.references :course, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.string :video_url
      t.integer :order_number, default: 0
      t.integer :duration_minutes, default: 0

      t.timestamps
    end

    add_index :lessons, [:course_id, :order_number]
  end
end
