class EmailTemplateUniqueness < ActiveRecord::Migration
  def change
    add_foreign_key "email_templates", "competitions", name: "email_templates_competition_id_fk"
  end
end
