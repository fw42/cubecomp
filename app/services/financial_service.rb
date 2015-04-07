class FinancialService
  def initialize(competition, pricing_model_class = nil)
    @competition = competition
    @pricing_model_class = pricing_model_class
  end

  def total_count
    competitors.size
  end

  def guest_count(*days)
    days.map{ |day| guests(day) }.flatten.uniq.size
  end

  def competing_competitors_count(*days)
    days.map{ |day| competing_competitors(day) }.flatten.uniq.size
  end

  def entrance_fee(day)
    fees = competitors.map{ |competitor| @pricing_model_class.new(competitor).entrance_fee(day) }.compact

    if fees.size == 0
      nil
    else
      fees.sum
    end
  end

  def entrance_fee_sum
    competitors.map{ |competitor| @pricing_model_class.new(competitor).entrance_fee_total }.sum
  end

  private

  def entrance_fee_from_guests(day)
    entrance_fee(guests(day), day)
  end

  def entrance_fee_from_competing_competitors(day)
    entrance_fee(competing_competitors(day), day)
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
      .preload(:days)
  end
end
