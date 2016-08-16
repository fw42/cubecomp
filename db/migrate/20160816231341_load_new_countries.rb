class LoadNewCountries < ActiveRecord::Migration
  def change
    load Rails.root.join("db/seeds/countries.rb")
  end
end
