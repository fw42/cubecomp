class RegistrationService
  def initialize(competitor)
    @competitor = competitor
  end

  def register_for_day!(day)
    @competitor.day_registrations.create!(
      competition: @competitor.competition,
      day: day
    )
  end

  def register_for_event(event)
    # TODO
  end
end
