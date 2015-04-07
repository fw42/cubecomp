class CurrencyEuroForAllCompetitions < ActiveRecord::Migration
  def change
    Competition.update_all(currency: '€')
  end
end
