class EmailTemplatesUnqiuenessIndex < ActiveRecord::Migration
  def change
    add_index :email_templates, [:competition_id, :name], unique: true
  end
end
