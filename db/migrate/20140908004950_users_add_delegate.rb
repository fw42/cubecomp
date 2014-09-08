class UsersAddDelegate < ActiveRecord::Migration
  def change
    add_column :users, :delegate, :boolean
  end
end
