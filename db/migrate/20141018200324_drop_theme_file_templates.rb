class DropThemeFileTemplates < ActiveRecord::Migration
  def change
    drop_table :theme_file_templates
  end
end
