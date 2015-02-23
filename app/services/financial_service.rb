class FinancialService
  def initialize(competition)
    @competition = competition
  end

  def entrance_fee_from_guests(day)
    entrance_fee(competitors.select{ |competitor| competitor.guest_on?(day.id) }, day)
  end

  def entrance_fee_from_competing_competitors(day)
    entrance_fee(competitors.select{ |competitor| competitor.competing_on?(day.id) }, day)
  end

  private

  def entrance_fee(competitors, day)
    competitors.reduce(0) do |total, competitor|
      total + competitor.entrance_fee(day)
    end
  end

  def competitors
    @competition
      .competitors
      .confirmed
      .preload(:events)
      .preload(:day_registrations)
  end
end
