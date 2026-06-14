class CreateQuizAttempts < ActiveRecord::Migration[8.1]
  def change
    create_table :quiz_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.integer :score
      t.boolean :passed
      t.datetime :submitted_at

      t.timestamps
    end
  end
end
