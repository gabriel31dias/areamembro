class AddUserIdToPlans < ActiveRecord::Migration[7.0]
  def change
    add_reference :plans, :user, foreign_key: true, index: true
  end
end
