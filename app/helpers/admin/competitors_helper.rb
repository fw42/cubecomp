module Admin::CompetitorsHelper
  def competitor_for_form(competitor)
    competition_days = competitor.competition.days
    competitor_days = competitor.days
    missing_days = competition_days - competitor_days

    missing_days.each do |day|
      competitor.day_registrations.build(day: day, competition: competitor.competition)
    end

    competitor
  end
end
