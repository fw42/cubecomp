class RenameThemeFilesHandle < ActiveRecord::Migration
  def change
    remove_column :theme_files, :handle
  end
end
