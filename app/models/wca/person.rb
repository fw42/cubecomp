class Wca::Person < ActiveRecord::Base
  establish_connection :wca
  self.table_name = "Persons"
  self.primary_key = "id"

  has_many :results, class_name: 'Wca::Result', foreign_key: "personID"

  def self.query(query)
    where("id LIKE ?", "#{query}%")
  end

  def as_json(*)
    super(only: [:id, :name, :gender, :countryId])
  end

  def first_name
    split_name.first
  end

  def last_name
    split_name.last
  end

  def self.number_of_competitions(wca_ids)
    Wca::Result
      .where(personId: wca_ids)
      .group('personId')
      .pluck(Arel.sql('personId, COUNT(DISTINCT(competitionId)) AS competitions'))
      .to_h
  end

  def self.anniversaries(wca_ids)
    anniversaries = number_of_competitions(wca_ids)
    anniversaries.each{ |key, value| anniversaries[key] = value + 1 }
    anniversaries.keep_if{ |key, value| value >= 10 && value % 5 == 0 }
  end

  private

  def split_name
    name.split(" ", 2)
  end
end
