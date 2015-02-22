class AddVersionColumnToUser2 < ActiveRecord::Migration
  def change
    remove_column :users, :version
    add_column :users, :version, :integer, null: false, default: 0
  end
end
