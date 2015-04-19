class CompetitorStatistics
  def initialize(competition, n = 10)
    @competition = competition
    @n = n
  end

  def oldest
    competitors.sort_by(&:age).reverse.slice(0, @n)
  end

  def youngest
    competitors.sort_by(&:age).slice(0, @n)
  end

  def events
    competitors.sort_by{ |c| c.event_registrations.size }.reverse.slice(0, @n)
  end

  def countries
    competitors.group_by(&:country).to_a.sort_by{ |_, cs| -cs.size }.slice(0, @n)
  end

  def average_age
    competitors.map(&:age).sum.to_f / competitors.size
  end

  def average_events
    competitors.map{ |c| c.event_registrations.size }.sum.to_f / competitors.size
  end

  private

  def competitors
    @competitors ||= @competition.competitors.confirmed.preload(:event_registrations)
  end
end
