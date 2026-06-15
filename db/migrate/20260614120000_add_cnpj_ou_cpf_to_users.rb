class AddCnpjOuCpfToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :cnpj_ou_cpf, :string
    add_index :users, :cnpj_ou_cpf
  end
end
