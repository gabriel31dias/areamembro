class CreateUserAchievements < ActiveRecord::Migration[8.1]
  def change
    create_table :user_achievements, id: :string do |t|
      t.references :user, null: false, foreign_key: true, type: :string
      t.string :achievement_key, null: false
      t.datetime :unlocked_at, null: false

      t.timestamps
    end

    add_index :user_achievements, [:user_id, :achievement_key], unique: true
  end
end
