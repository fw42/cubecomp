class MoreFks < ActiveRecord::Migration
  def change
    add_foreign_key "competitions", "locales", name: "competitions_default_locale_id_fk", column: "default_locale_id"
  end
end
