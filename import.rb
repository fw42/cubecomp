require "./config/environment.rb"
require "./importer/importer.rb"
require "./importer/competition.rb"
require "./importer/news.rb"
require "./importer/event.rb"
require "./importer/competitor.rb"

raise "Missing LEGACY_DB" unless ENV['LEGACY_DB'].present?
raise "Missing HANDLE" unless ENV['HANDLE'].present?

Competition.transaction do
  if existing = Competition.where(handle: ENV['HANDLE']).first
    old_id = existing.id
    existing.destroy!
  end

  competition = Importer::Competition.new(ENV['HANDLE']).import
  competition.id = old_id
  competition.save!

  Importer::News.new(competition).import
  Importer::Event.new(competition).import

  Importer::Competitor.new(competition).import
  competition.save!
end
