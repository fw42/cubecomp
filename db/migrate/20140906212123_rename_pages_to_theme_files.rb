class RenamePagesToThemeFiles < ActiveRecord::Migration
  def up
    rename_table :pages, :theme_files
    remove_column :theme_files, :locale_id
    remove_column :theme_files, :page_body_id
    add_column :theme_files, :content, :text
  end

  def down
    remove_column :theme_files, :content
    add_column :theme_files, :page_body_id, :integer
    add_column :theme_files, :locale_id, :integer
    rename_table :theme_files, :pages
  end
end
