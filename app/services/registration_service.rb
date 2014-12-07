class RegistrationService
  def initialize(competitor)
    @competitor = competitor
  end

  def register_for_day(day_id)
    return if @competitor.registered_on?(day_id)
    @competitor.day_registrations.build(
      competition_id: @competitor.competition.id,
      day_id: day_id,
    )
  end

  def register_as_guest(day_id)
    registration = register_for_day(day_id)
    unregister_from_events_on_day(day_id)
    registration
  end

  def register_for_event(event, waiting = false)
    register_for_day(event.day_id)

    registration = @competitor.event_registrations.build(
      competition_id: @competitor.competition.id,
      event_id: event.id,
    )

    registration.waiting = waiting
    registration
  end

  def unregister_from_day(day_id)
    @competitor.day_registrations.each do |registration|
      next unless registration.competition_id == @competitor.competition.id
      next unless registration.day_id == day_id
      registration.mark_for_destruction
    end
  end

  def unregister_from_event(event_id)
    @competitor.event_registrations.each do |registration|
      next unless registration.competition_id == @competitor.competition.id
      next unless registration.event_id == event_id
      registration.mark_for_destruction
    end
  end

  def unregister_from_events_on_day(day_id)
    @competitor.event_registrations.select do |registration|
      if registration.event.day_id == day_id
        registration.mark_for_destruction
      end
    end
  end
end
