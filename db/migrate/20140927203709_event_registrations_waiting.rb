class EventRegistrationsWaiting < ActiveRecord::Migration
  def change
    add_column :event_registrations, :waiting, :boolean, default: false, null: false
  end
end
