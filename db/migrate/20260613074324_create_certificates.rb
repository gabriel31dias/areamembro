class CreateCertificates < ActiveRecord::Migration[8.1]
  def change
    create_table :certificates, id: :string do |t|
      t.references :user, null: false, foreign_key: true, type: :string
      t.references :course, null: false, foreign_key: true, type: :string
      t.string :code, null: false
      t.datetime :issued_at, null: false

      t.timestamps
    end

    add_index :certificates, :code, unique: true
    add_index :certificates, [:user_id, :course_id], unique: true
  end
end
