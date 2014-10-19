class AddMoreForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key "theme_files", "themes", name: "theme_files_theme_id_fk"
  end
end
