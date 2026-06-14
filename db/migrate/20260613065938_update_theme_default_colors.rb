class UpdateThemeDefaultColors < ActiveRecord::Migration[8.1]
  def up
    change_column_default :themes, :primary_color,    "#6366f1"
    change_column_default :themes, :secondary_color,  "#a855f7"
    change_column_default :themes, :background_color, "#070a13"
    change_column_default :themes, :surface_color,    "#0e1424"
    change_column_default :themes, :text_color,       "#f9fafb"
    change_column_default :themes, :muted_text_color, "#9ca3af"
  end

  def down
    change_column_default :themes, :primary_color,    "#00d4ff"
    change_column_default :themes, :secondary_color,  "#0066ff"
    change_column_default :themes, :background_color, "#f8fafc"
    change_column_default :themes, :surface_color,    "#ffffff"
    change_column_default :themes, :text_color,       "#0a0e27"
    change_column_default :themes, :muted_text_color, "#64748b"
  end
end
