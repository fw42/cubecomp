class CreateThemeFileTemplates < ActiveRecord::Migration
  def change
    create_table :theme_file_templates do |t|
      t.string :filename
      t.text :content
      t.timestamps
    end
  end
end
