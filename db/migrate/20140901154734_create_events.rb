class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :competition
      t.references :day
      t.string :name_short
      t.string :name_long
      t.string :handle
      t.string :state
      t.integer :max_number_of_registrations
      t.time :start_time
      t.integer :length_in_minutes
      t.string :timelimit
      t.string :format
      t.string :round
      t.string :proceed
      t.timestamps
    end
  end
end
