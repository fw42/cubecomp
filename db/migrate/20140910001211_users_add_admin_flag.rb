class UsersAddAdminFlag < ActiveRecord::Migration
  def change
    remove_column :users, :super_admin
    add_column :users, :permission_level, :integer
  end
end
