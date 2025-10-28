class CreateEbooks < ActiveRecord::Migration[7.0]
  def change
    create_table :ebooks do |t|
      t.string :title, null: false
      t.text :description
      t.string :author
      t.integer :pages, default: 0
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :ebooks, :active
  end
end
