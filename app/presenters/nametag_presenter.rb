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
    wca_competitor.try(:competition_count) || 0
  end

  def best_333_result
    @wca_gateway.find_records_for(competitor.wca, "333") if competitor.wca_account?
  end

  private

  attr_reader :competitor

  def wca_competitor
    return nil unless competitor.wca_account?

    @wca_competitor ||= @wca_gateway.find_by_id(competitor.wca)
  end
end
