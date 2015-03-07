class FinancialService
  def initialize(competition)
    @competition = competition
  end

  def guest_count(day)
    guests(day).size
  end

  def entrance_fee_from_guests(day)
    entrance_fee(guests(day), day)
  end

  def competing_competitors_count(day)
    competing_competitors(day).size
  end

  def entrance_fee_from_competing_competitors(day)
    entrance_fee(competing_competitors(day), day)
  end

  private

  def entrance_fee(competitors, day)
    competitors.reduce(0) do |total, competitor|
      total + competitor.entrance_fee(day)
    end
  end

  def guests(day)
    competitors.select{ |competitor| competitor.guest_on?(day.id) }
  end

  def competing_competitors(day)
    competitors.select{ |competitor| competitor.competing_on?(day.id) }
  end

  def competitors
    @competitors ||= @competition
      .competitors
      .confirmed
      .preload(:events)
      .preload(:day_registrations)
  end
end
