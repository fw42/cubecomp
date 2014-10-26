class AddThemeIdToThemeFiles < ActiveRecord::Migration
  def change
    add_column :theme_files, :theme_id, :integer
  end
end
