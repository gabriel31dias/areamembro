class AddApiCredentialsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :api_key, :string
    add_column :users, :api_secret, :string
  end
end
