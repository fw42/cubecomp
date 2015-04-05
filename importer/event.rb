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
      })

      if legacy.respond_to?(:proceed)
        new_event.proceed = legacy.proceed
      end

      if legacy.respond_to?(:max_competitors)
        new_event.max_number_of_registrations = legacy.max_competitors
      end

      new_event.day = days[legacy.day]

      new_event.length_in_minutes = if legacy.stop
        ((legacy.stop - legacy.start) / 60).to_i
      end

      if new_event.length_in_minutes && new_event.length_in_minutes <= 0
        new_event.length_in_minutes = nil
      end

      new_event.state = ::Event::STATES.keys[legacy.status]

      if new_event.name_short == "Team Solve (Registration on location)"
        new_event.name_short = 'Team Solve'
        new_event.state = 'open_for_registration'
      end

      if !new_event.for_registration? && new_event.handle.present?
        new_event.handle = nil
      end

      new_event.save!
      MAPPING[legacy.id] = new_event.id
    end
  end
end
