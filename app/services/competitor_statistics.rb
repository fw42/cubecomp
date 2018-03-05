class CompetitorStatistics
  def initialize(competition, count = 10)
    @competition = competition
    @count = count
  end

  def oldest
    competing_competitors.sort_by(&:age).reverse.slice(0, @count)
  end

  def youngest
    competing_competitors.sort_by(&:age).slice(0, @count)
  end

  def events
    competing_competitors.sort_by{ |c| c.event_registrations.size }.reverse.slice(0, @count)
  end

  def countries
    competing_competitors.group_by(&:country).to_a.sort_by{ |_, cs| -cs.size }.slice(0, @count)
  end

  def average_age
    competing_competitors.map(&:age).sum.to_f / competing_competitors.size
  end

  def average_events
    competing_competitors.map{ |c| c.event_registrations.size }.sum.to_f / competing_competitors.size
  end

  private

  def competing_competitors
    @competing_competitors ||= @competition
      .competitors
      .confirmed
      .preload(:event_registrations)
      .preload(:country)
      .select(&:competing?)
  end
end
