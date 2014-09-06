class RenamePageTemplateBodies < ActiveRecord::Migration
  def up
    rename_table :page_template_bodies, :page_bodies
  end

  def down
    rename_table :page_bodies, :page_template_bodies
  end
end
