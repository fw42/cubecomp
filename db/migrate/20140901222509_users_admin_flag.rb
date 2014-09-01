class UsersAdminFlag < ActiveRecord::Migration
  def up
    remove_column :permissions, :admin
    add_column :users, :super_admin, :boolean
  end

  def down
    remove_column :users, :super_admin
    add_column :permissions, :admin, :boolean
  end
end
