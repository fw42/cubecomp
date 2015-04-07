class PricingModel::PerDayDiscounted < PricingModel
  delegate :entrance_fee_total, :entrance_fee, to: :pricing_model

  private

  def pricing_model
    @pricing_model ||= begin
      if registered_on_all_days?
        PricingModel::PerCompetition.new(@competitor)
      else
        PricingModel::PerDay.new(@competitor)
      end
    end
  end

  def registered_on_all_days?
    @competitor.days.size == @competition.days.size
  end
end
