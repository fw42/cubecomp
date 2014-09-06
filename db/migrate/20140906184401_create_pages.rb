class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.references :competition
      t.string :handle
      t.integer :page_template_body_id
      t.timestamps
      t.index :handle
    end
  end
end
