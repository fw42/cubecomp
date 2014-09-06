class CreatePageTemplateBodies < ActiveRecord::Migration
  def change
    create_table :page_template_bodies do |t|
      t.text :content
      t.timestamps
    end
  end
end
