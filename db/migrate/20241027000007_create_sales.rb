class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :payment_method
      t.string :status, default: 'pending'
      t.text :notes

      t.timestamps
    end

    add_index :sales, :status
    add_index :sales, :created_at
  end
end
