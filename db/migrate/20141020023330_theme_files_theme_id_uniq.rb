class ThemeFilesThemeIdUniq < ActiveRecord::Migration
  def change
    add_index :theme_files, :theme_id, unique: true
  end
end
