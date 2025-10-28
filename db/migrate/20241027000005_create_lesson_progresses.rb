class CreateLessonProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :lesson_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.boolean :completed, default: false
      t.integer :watched_seconds, default: 0
      t.datetime :completed_at

      t.timestamps
    end

    add_index :lesson_progresses, [:user_id, :lesson_id], unique: true
  end
end
