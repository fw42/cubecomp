class DayEventsImportService
  def initialize(day_from, day_to)
    @day_from = day_from
    @day_to = day_to
  end

  def replace!
    remove_existing_events
    @day_to.save!

    copy_events
    @day_to.save!
  end

  private

  def copy_events
    @day_from.events.each do |event|
      new_event = event.dup
      new_event.day_id = @day_to.id
      new_event.competition_id = @day_to.competition_id
      @day_to.events.build(new_event.attributes)
    end
  end

  def remove_existing_events
    @day_to.events.each(&:mark_for_destruction)
  end
end
