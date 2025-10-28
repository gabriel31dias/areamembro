class AddUserIdToEbooks < ActiveRecord::Migration[7.0]
  def change
    add_reference :ebooks, :user, foreign_key: true, index: true
  end
end
