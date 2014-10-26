class ThemeFilesThemeIdUniq2 < ActiveRecord::Migration
  def change
    add_index :theme_files, [ :theme_id, :filename ], unique: true
    remove_index :theme_files, :theme_id
  end
end
