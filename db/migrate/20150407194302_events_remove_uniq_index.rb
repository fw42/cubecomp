class EventsRemoveUniqIndex < ActiveRecord::Migration
  def change
    remove_index :events, :handle_and_competition_id
  end
end
