class AddSubscriptionFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :status, :string, default: 'active'
    add_column :users, :subscription_status, :string, default: 'free'
    add_column :users, :blocked_at, :datetime
    add_column :users, :name, :string

    add_index :users, :status
    add_index :users, :subscription_status
  end
end
