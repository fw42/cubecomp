class DropImageFileName < ActiveRecord::Migration
  def change
    remove_column :theme_files, :image_file_name
  end
end
