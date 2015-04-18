class AddUsefulDefaults < ActiveRecord::Migration
  def change
    Competition.preload(:days).find_each do |competition|
      competition.entrance_fee_competitors = competition.days.map{ |d| d.entrance_fee_competitors }.sum
      competition.entrance_fee_guests = competition.days.map{ |d| d.entrance_fee_guests }.sum
      competition.save!
    end
  end
end
