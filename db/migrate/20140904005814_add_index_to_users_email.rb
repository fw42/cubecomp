class AddIndexToUsersEmail < ActiveRecord::Migration
  def up
    add_index :users, :email
  end

  def down
    remove_index :users, :email
  end
end
