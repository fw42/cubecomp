class Importer::Event < Importer
  MAPPING = {}

  def import
    days = @competition.days.sort_by(&:date)

    LegacyEvent.all.each do |legacy|
      new_event = @competition.events.build

      class << new_event
        attr_accessor :legacy_id
      end

      assign_values(new_event, legacy, {
        :name_short => :name,
        :name => :long_name,
        :start_time => :start,
        :timelimit => :timelimit,
        :format => :format,
        :round => :round,
        :handle => :code,
        :max_number_of_registrations => :max_competitors,
      })

      if legacy.respond_to?(:proceed)
        new_event.proceed = legacy.proceed
      end

      new_event.day = days[legacy.day]

      new_event.length_in_minutes = if legacy.stop
        ((legacy.stop - legacy.start) / 60).to_i
      end

      if new_event.length_in_minutes == 0
        new_event.length_in_minutes = nil
      end

      new_event.state = ::Event::STATES.keys[legacy.status]
      new_event.save!
      MAPPING[legacy.id] = new_event.id
    end
  end
end
