class Highcharts
  def initialize(competition)
    @competition = competition
  end

  def competing_competitors_by_date
    competitors_by_date(competitors.select(&:competing?))
  end

  def guests_by_date
    competitors_by_date(competitors.reject(&:competing?))
  end

  def events_by_code
    h = {}
    competitors.each do |competitor|
      competitor.event_registrations.reject(&:waiting?).each do |registration|
        event = registration.event
        h[event.handle] ||= {}
        key = competitor.wca.blank? ? :newcomer : :non_newcomer
        h[event.handle][key] ||= 0
        h[event.handle][key] += 1
      end
    end

    h.to_a.sort_by{ |handle, stats| stats.values.sum }
  end

  def countries
    h = {}

    competitors.each do |competitor|
      key = competitor.country.name
      h[key] ||= 0
      h[key] += 1
    end

    h
  end

  def days
    h = {}

    competitors.each do |competitor|
      @competition.days.each do |day|
        h[day] ||= {}

        if competitor.competing_on?(day)
          h[day][:competitors] ||= 0
          h[day][:competitors] += 1
        elsif competitor.guest_on?(day)
          h[day][:guests] ||= 0
          h[day][:guests] += 1
        end
      end
    end

    h.to_a.sort_by{ |day, stats| day.date }
  end

  private

  def competitors_by_date(competitors)
    h = {}
    sum = 0

    competitors.each do |competitor|
      key = competitor.created_at.to_date
      h[key] = (sum += 1)
    end

    h
  end

  def competitors
    @competitors ||= @competition.competitors
      .confirmed
      .preload(:event_registrations => :event)
      .preload(:events)
      .preload(:country)
  end
end
