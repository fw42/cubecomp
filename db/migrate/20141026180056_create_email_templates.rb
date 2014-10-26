class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.references :competition, null: false
      t.string :name, null: false
      t.text :content, null: false
      t.timestamps
    end
  end
end
