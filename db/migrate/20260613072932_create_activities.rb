class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities, id: :string do |t|
      t.references :user, null: false, foreign_key: true, type: :string
      t.string :activity_type, null: false
      t.string :title
      t.text :description
      t.json :metadata, default: {}
      t.datetime :occurred_at, null: false

      t.timestamps
    end

    add_index :activities, [:user_id, :occurred_at]
    add_index :activities, :activity_type
  end
end
