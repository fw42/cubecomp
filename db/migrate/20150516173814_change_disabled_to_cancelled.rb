class ChangeDisabledToCancelled < ActiveRecord::Migration
  def change
    Competitor.where(state: 'disabled').update_all(state: 'cancelled')
  end
end
