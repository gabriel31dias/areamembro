class CreateCourseProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :course_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.integer :completed_lessons, default: 0
      t.decimal :percentage, precision: 5, scale: 2, default: 0.0
      t.datetime :last_accessed_at

      t.timestamps
    end

    add_index :course_progresses, [:user_id, :course_id], unique: true
  end
end
