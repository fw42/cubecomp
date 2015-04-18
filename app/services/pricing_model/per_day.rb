class PricingModel::PerDay < PricingModel
  def entrance_fee_total
    @competition.days.map{ |day| entrance_fee(day) }.sum
  end

  def entrance_fee(day)
    if @competitor.free_entrance?
      0
    elsif @competitor.competing_on?(day.id)
      day.entrance_fee_competitors
    elsif @competitor.guest_on?(day.id)
      day.entrance_fee_guests
    else
      0
    end
  end
end
