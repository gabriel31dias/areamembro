class SetMemberAreaDefaults < ActiveRecord::Migration[8.1]
  def up
    change_column_default :themes, :member_area_title, "CATÁLOGO OFICIAL ALURADEV"
    change_column_default :themes, :primary_description, "Aprenda no seu ritmo. Evolua com prática."
    change_column_default :themes, :secondary_description, "Consulte abaixo somente os cursos disponíveis para sua conta, carregados diretamente da plataforma."
  end

  def down
    change_column_default :themes, :member_area_title, "Área de Membros"
    change_column_default :themes, :primary_description, nil
    change_column_default :themes, :secondary_description, nil
  end
end
