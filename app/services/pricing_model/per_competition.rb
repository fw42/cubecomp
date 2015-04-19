class PricingModel::PerCompetition < PricingModel
  def entrance_fee_total
    if @competitor.free_entrance?
      0
    elsif @competitor.competing?
      @competition.entrance_fee_competitors
    else
      @competition.entrance_fee_guests
    end
  end

  def entrance_fee(_day)
    nil
  end
end
