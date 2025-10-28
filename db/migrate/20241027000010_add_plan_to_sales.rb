class AddPlanToSales < ActiveRecord::Migration[8.1]
  def change
    add_reference :sales, :plan, foreign_key: true
  end
end
