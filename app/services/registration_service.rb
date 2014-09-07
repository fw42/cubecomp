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

  def register_for_event!(event)
    EventRegistration.transaction do
      if !@competitor.registered_on?(event.day_id)
        register_for_day!(event.day_id)
      end

      @competitor.event_registrations.create!(
        competition: @competitor.competition,
        event: event
      )
    end
  end
end
