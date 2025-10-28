class AddUserIdToCourses < ActiveRecord::Migration[7.0]
  def change
    add_reference :courses, :user, foreign_key: true, index: true
  end
end
