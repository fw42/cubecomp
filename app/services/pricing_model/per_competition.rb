class PricingModel::PerCompetition < PricingModel
  def entrance_fee_total
    if @competitor.free_entrance?
      0
    elsif competing_on_at_least_one_day?
      @competition.entrance_fee_competitors
    else
      @competition.entrance_fee_guests
    end
  end

  def entrance_fee(_day)
    nil
  end

  private

  def competing_on_at_least_one_day?
    @competitor.event_registrations.size > 0
  end
end
