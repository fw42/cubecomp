#!/usr/bin/ruby

class Wca::Person < ActiveRecord::Base
  establish_connection :wca
  self.table_name = "Persons"
  self.primary_key = "id"

  has_many :results, class_name: Wca::Result, foreign_key: "personID"

  def first_name
    split_name.first
  end

  def last_name
    split_name.last
  end

  def split_name
    name.split(" ", 2)
  end

  def best_single(wca_event_id)
    results.where(eventId: wca_event_id).where("best > 0").pluck("MIN(best)").first
  end

  def best_average(wca_event_id)
    results.where(eventId: wca_event_id).where("average > 0").pluck("MIN(average)").first
  end

  def self.number_of_competitions(wca_ids)
    Wca::Result
      .where(personId: wca_ids)
      .group('personId')
      .pluck('personId, COUNT(DISTINCT(competitionId)) AS competitions')
      .to_h
  end
end
