class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name
      t.string :handle
      t.string :staff_email
      t.string :staff_name
      t.string :city_name
      t.string :city_name_short
      t.string :venue_address

      t.integer :default_registration_country_id

      t.boolean :cc_orga, default: false
      t.boolean :registration_open, default: false

      t.timestamps
    end
  end
end
