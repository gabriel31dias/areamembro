class CreateUserPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :user_plans do |t|
      t.references :user, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.string :status, default: 'active'
      t.datetime :expires_at

      t.timestamps
    end

    add_index :user_plans, [:user_id, :status]
    add_index :user_plans, :expires_at
  end
end
