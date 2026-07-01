class CreateQuestionOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :question_options, id: :string do |t|
      t.references :question, null: false, foreign_key: true, type: :string
      t.string :text
      t.boolean :correct, default: false

      t.timestamps
    end
  end
end
