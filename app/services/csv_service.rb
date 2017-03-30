class CsvService
  def initialize(competition)
    @competition = competition
  end

  def handles
    @handles ||= competition
      .events
      .for_registration
      .map{ |event| event.wca_handle || event.handle }
      .compact
      .sort
      .uniq
  end

  def active_competitors
    all_competitors.reject do |competitor|
      competitor.event_registrations.reject(&:waiting).empty?
    end
  end

  def active_and_waiting
    all_competitors.reject do |competitor|
      competitor.event_registrations.empty?
    end
  end

  def active_guests
    all_competitors.select do |competitor|
      competitor.event_registrations.reject(&:waiting).empty?
    end
  end

  def header_to_csv(with_handles: true)
    header = [
      'Status',
      'Name',
      'Country',
      'WCA ID',
      'Birth Date',
      'Gender',
      ''
    ]

    header << handles if with_handles
    header.join(',')
  end

  def competitor_to_csv(competitor, with_handles: true)
    data = data_for_csv(competitor)

    if with_handles
      handles.each do |handle|
        registered = !competitor.events.select{ |event| [event.wca_handle, event.handle].include?(handle) }.empty?
        data << (registered ? '1' : '0')
      end
    end

    data.join(',')
  end

  private

  attr_reader :competition

  def data_for_csv(competitor)
    [
      competitor.confirmed? ? "a" : "p",
      competitor.name,
      competitor.country.name,
      competitor.wca,
      competitor.birthday.strftime('%Y-%m-%d'),
      competitor.male? ? 'm' : 'f',
      ''
    ]
  end

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
