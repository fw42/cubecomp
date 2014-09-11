class DaysAddEntranceFees < ActiveRecord::Migration
  def change
    add_column :days, :entrance_fee_competitors, :decimal, precision: 10, scale: 2
    add_column :days, :entrance_fee_guests, :decimal, precision: 10, scale: 2
  end
end
