class CreateDayRegistrations < ActiveRecord::Migration
  def change
    create_table :day_registrations do |t|
      t.references :competition
      t.integer :competitor_id
      t.integer :day_id
      t.timestamps
    end
  end
end
