class BackfillUserDelegate < ActiveRecord::Migration
  def change
    User.find_each do |user|
      competitor = Competitor.find_by(email: user.email)
      competitor ||= Competitor.find_by(first_name: user.first_name, last_name: user.last_name)
      next unless competitor
      user.wca = competitor.wca
      user.save!
    end
  end
end
