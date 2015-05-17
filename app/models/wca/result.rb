#!/usr/bin/ruby

class Wca::Result < ActiveRecord::Base
  establish_connection :wca
  self.table_name = "Results"

  def self.single_ranking(wca_event_handle, wca_ids)
    where(eventId: wca_event_handle, personId: wca_ids)
      .where('best > 0')
      .group('personId')
      .pluck('personId, MIN(best)')
      .to_h
  end

  def self.average_ranking(wca_event_handle, wca_ids)
    where(eventId: wca_event_handle, personId: wca_ids)
      .where('average > 0')
      .group('personId')
      .pluck('personId, MIN(average)')
      .to_h
  end

  def self.single_records(wca_country_id = nil)
    results = where("best > 0")
    results = results.where(personCountryId: wca_country_id) if wca_country_id
    results.group('eventId').pluck('eventId, MIN(best)').to_h
  end

  def self.average_records(wca_country_id = nil)
    results = where("average > 0")
    results = results.where(personCountryId: wca_country_id) if wca_country_id
    results.group('eventId').pluck('eventId, MIN(average)').to_h
  end
end
