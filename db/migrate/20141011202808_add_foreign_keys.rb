class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key "competitions", "users", name: "competitions_owner_user_id_fk", column: "owner_user_id"
  end
end
