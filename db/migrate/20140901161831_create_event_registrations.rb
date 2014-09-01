class CreateEventRegistrations < ActiveRecord::Migration
  def change
    create_table :event_registrations do |t|
      t.references :competition
      t.references :event
      t.references :competitor
      t.timestamps
    end
  end
end
