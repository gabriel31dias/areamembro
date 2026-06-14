class AddMemberAreaTitleToThemes < ActiveRecord::Migration[8.1]
  def change
    add_column :themes, :member_area_title, :string, default: "Área de Membros"
  end
end
