class DropNameColumn < ActiveRecord::Migration
  def change
    remove_column :events, :name
    rename_column :events, :name_short, :name
  end
end
