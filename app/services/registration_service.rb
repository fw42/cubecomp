class RegistrationService
  def initialize(competitor)
    @competitor = competitor
  end

  def register_for_day!(day_or_day_id)
    @competitor.day_registrations.where(
      competition_id: @competitor.competition.id,
      day_id: day_id(day_or_day_id)
    ).first_or_create!
  end

  def unregister_from_day!(day_or_day_id)
    rel = @competitor.day_registrations.where(
      competition_id: @competitor.competition.id,
      day_id: day_id(day_or_day_id)
    )

    rel.each(&:destroy!)
  end

  def register_as_guest!(day_or_day_id)
    register_for_day!(day_or_day_id)
    @competitor.event_registrations.on_day(day_id(day_or_day_id)).each(&:destroy!)
  end

  def register_for_event!(event, waiting = false)
    unless @competitor.registered_on?(event.day_id)
      register_for_day!(event.day_id)
    end

    registration = @competitor.event_registrations.where(
      competition_id: @competitor.competition.id,
      event: event,
    ).first_or_initialize

    registration.waiting = waiting
    registration.save!
  end

  def unregister_from_event!(event_or_event_id)
    rel = @competitor.event_registrations.where(
      competition_id: @competitor.competition.id,
      event: event_or_event_id
    )

    rel.each(&:destroy!)
  end

  private

  def day_id(day_or_day_id)
    day_or_day_id.is_a?(Day) ? day_or_day_id.id : day_or_day_id
  end
end
