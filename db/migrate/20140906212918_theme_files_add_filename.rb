class ThemeFilesAddFilename < ActiveRecord::Migration
  def change
    add_column :theme_files, :filename, :string
  end
end
