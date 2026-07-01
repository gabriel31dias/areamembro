class CreateCourseProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :course_progresses, id: :string do |t|
      t.references :user, null: false, foreign_key: true, type: :string
      t.references :course, null: false, foreign_key: true, type: :string
      t.integer :completed_lessons, default: 0
      t.decimal :percentage, precision: 5, scale: 2, default: 0.0
      t.datetime :last_accessed_at

      t.timestamps
    end

    add_index :course_progresses, [:user_id, :course_id], unique: true
  end
end
