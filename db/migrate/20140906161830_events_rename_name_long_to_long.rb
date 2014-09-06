class EventsRenameNameLongToLong < ActiveRecord::Migration
  def up
    rename_column :events, :name_long, :name
  end

  def down
    rename_column :events, :name, :name_long
  end
end
