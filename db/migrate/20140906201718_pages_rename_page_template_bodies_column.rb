class PagesRenamePageTemplateBodiesColumn < ActiveRecord::Migration
  def up
    rename_column :pages, :page_template_body_id, :page_body_id
  end

  def down
    rename_column :pages, :page_body_id, :page_template_body_id
  end
end
