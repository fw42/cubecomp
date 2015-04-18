class PricingModel
  def initialize(competitor)
    @competitor = competitor
    @competition = competitor.competition
  end

  def entrance_fee(_day)
    raise NotImplementedError
  end

  def entrance_fee_total
    raise NotImplementedError
  end

  def self.for_handle(handle)
    case handle
    when 'per_day'
      PricingModel::PerDay
    when 'per_competition'
      PricingModel::PerCompetition
    when 'per_day_discounted'
      PricingModel::PerDayDiscounted
    end
  end
end
