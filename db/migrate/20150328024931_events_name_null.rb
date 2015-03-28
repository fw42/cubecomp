class EventsNameNull < ActiveRecord::Migration
  def change
    change_column_null :events, :name, true
  end
end
