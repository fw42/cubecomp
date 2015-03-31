class NametagPresenter
  delegate :name,
    :staff?,
    :country,
    :local,
    :nametag,
    to: :competitor

  def initialize(competitor, wca_gateway)
    @competitor = competitor
    @wca_gateway = wca_gateway
  end

  def competition_count
    if competitor.wca_account?
      wca_competitor = @wca_gateway.find_by_id(competitor.wca)
      if wca_competitor
        wca_competitor.competition_count
      else
        0
      end
    else
      0
    end
  end

  def best_333_result
    @wca_gateway.find_records_for(competitor.wca, "333") if competitor.wca_account?
  end

  private

  attr_reader :competitor
end
