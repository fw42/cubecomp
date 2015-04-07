class CompetitionsPricingStuff < ActiveRecord::Migration
  def change
    options = { precision: 10, scale: 2, default: 0, null: false }
    add_column :competitions, :entrance_fee_competitors, :decimal, options
    add_column :competitions, :entrance_fee_guests, :decimal, options

    add_column :competitions, :pricing_model, :string
    Competition.update_all(pricing_model: 'per_day')
    change_column :competitions, :pricing_model, :string, null: false
  end
end
