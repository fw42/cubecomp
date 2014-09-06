class DropPageBodies < ActiveRecord::Migration
  def change
    drop_table :page_bodies
  end
end
