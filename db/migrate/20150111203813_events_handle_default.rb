class EventsHandleDefault < ActiveRecord::Migration
  def change
    change_column :events, :handle, :string, null: true
  end
end
