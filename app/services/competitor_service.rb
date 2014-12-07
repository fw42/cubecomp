class CompetitorService
  def initialize(competitor)
    @competitor = competitor
  end

  def save(params)
    @competitor.attributes = params.except(:days)
    apply_registration_params(params[:days]) if params[:days]
    @competitor.save
  end

  private

  def apply_registration_params(params)
    params.each do |day_id, day_attributes|
      if day_attributes[:status] == 'not_registered'
        @competitor.registration_service.unregister_from_day(day_id.to_i)
        next
      elsif day_attributes[:status] == 'guest'
        @competitor.registration_service.register_as_guest(day_id.to_i)
        next
      end

      apply_event_registration_params(day_attributes[:events])
    end
  end

  def apply_event_registration_params(attributes)
    attributes.each do |event_id, event_attributes|
      if event_attributes[:status] == 'not_registered'
        @competitor.registration_service.unregister_from_event(event_id.to_i)
      else
        @competitor.registration_service.register_for_event(
          @competitor.competition.events.find(event_id),
          event_attributes[:status] == 'waiting'
        )
      end
    end
  end
end
