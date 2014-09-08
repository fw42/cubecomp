class RegistrationService
  def initialize(competitor)
    @competitor = competitor
  end

  def register_for_day!(day_or_day_id)
    @competitor.day_registrations.create!(
      competition: @competitor.competition,
      day_id: day_or_day_id.is_a?(Day) ? day_or_day_id.id : day_or_day_id
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
