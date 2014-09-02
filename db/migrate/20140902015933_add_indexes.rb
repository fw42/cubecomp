class AddIndexes < ActiveRecord::Migration
  def up
    add_index :competitors, :competition_id
    add_index :days, :competition_id
    add_index :events, :competition_id
    add_index :event_registrations, :competition_id
    add_index :news, :competition_id
    add_index :permissions, [:competition_id, :user_id]
  end

  def down
    remove_index :competitors, :competition_id
    remove_index :days, :competition_id
    remove_index :events, :competition_id
    remove_index :event_registrations, :competition_id
    remove_index :news, :competition_id
    remove_index :permissions, [:competition_id, :user_id]
  end
end
