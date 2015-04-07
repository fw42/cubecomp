class CsvService
  def initialize(competition)
    @competition = competition
  end

  def handles
    @handles ||= competition.events
      .where(state: 'open_for_registration')
      .pluck(:handle)
      .compact.sort.uniq
  end

  def active_competitors
    all_competitors.select do |competitor|
      competitor.event_registrations.reject(&:waiting).size > 0
    end
  end

  def active_and_waiting
    all_competitors.select do |competitor|
      competitor.event_registrations.size > 0
    end
  end

  def active_guests
    all_competitors.select do |competitor|
      competitor.event_registrations.reject(&:waiting).size == 0
    end
  end

  def header_to_csv(with_handles: true)
    header = [
      'Name',
      'Country',
      'WCA ID',
      'Gender',
      'Birthdate',
      '', '', ''
    ]

    header << handles if with_handles
    header.join(',')
  end

  def competitor_to_csv(competitor, with_handles: true)
    data = [
      competitor.name,
      competitor.country.name,
      competitor.wca,
      competitor.male? ? 'm' : 'f',
      competitor.birthday.strftime('%Y-%m-%d'),
      '', '',  ''
    ]

    if with_handles
      handles.each do |handle|
        registered = competitor.events.select{ |event| event.handle == handle }.size > 0
        data << (registered ? '1' : '0')
      end
    end

    data.join(',')
  end

  private

  attr_reader :competition

  def all_competitors
    @all_competitors ||= competition
      .competitors
      .confirmed
      .includes(:country)
      .includes(:event_registrations)
      .includes(:events)
      .includes(:day_registrations)
  end
end
