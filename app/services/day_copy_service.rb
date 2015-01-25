class DayCopyService
  def initialize(day_to, day_from = nil)
    @day_to = day_to
    @day_from = day_from
  end

  def replace_events!
    @day_to.transaction do
      remove_existing_events_from_day
      @day_to.save!

      copy_events_to_day
      @day_to.save!
    end
  end

  def copy_events_to_day
    @day_from.events.each do |event|
      new_event = event.dup
      new_event.day_id = @day_to.id
      new_event.competition_id = @day_to.competition_id
      @day_to.events.build(new_event.attributes)
    end
  end

  def remove_existing_events_from_day
    @day_to.events.each(&:mark_for_destruction)
  end
end
