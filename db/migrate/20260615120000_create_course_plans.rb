class CreateCoursePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :course_plans, id: :string do |t|
      t.references :course, null: false, foreign_key: true, type: :string
      t.references :plan, null: false, foreign_key: true, type: :string

      t.timestamps
    end

    add_index :course_plans, [:course_id, :plan_id], unique: true
  end
end
