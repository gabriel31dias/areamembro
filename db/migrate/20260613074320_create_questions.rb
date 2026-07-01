class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions, id: :string do |t|
      t.references :quiz, null: false, foreign_key: true, type: :string
      t.text :statement
      t.integer :order_number

      t.timestamps
    end
  end
end
