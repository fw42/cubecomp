class Wca::RanksSingle < ActiveRecord::Base
  establish_connection :wca
  self.table_name = "RanksSingle"

  def self.for_event(wca_ids, wca_event_handle)
    ranks = where(personId: wca_ids, eventId: wca_event_handle).group_by(&:personId)

    ranks.each do |wca_id, rank|
      ranks[wca_id] = rank.first
    end

    ranks
  end
end
