class CreateQuizzes < ActiveRecord::Migration[8.1]
  def change
    create_table :quizzes, id: :string do |t|
      t.references :course, null: false, foreign_key: true, index: { unique: true }, type: :string
      t.string :title
      t.integer :passing_score, default: 70

      t.timestamps
    end
  end
end
