class UsersAddWcaId < ActiveRecord::Migration
  def change
    add_column :users, :wca, :string
  end
end
