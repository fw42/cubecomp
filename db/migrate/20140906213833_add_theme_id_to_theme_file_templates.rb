class AddThemeIdToThemeFileTemplates < ActiveRecord::Migration
  def change
    add_column :theme_file_templates, :theme_id, :integer
    add_index :theme_file_templates, :theme_id
  end
end
