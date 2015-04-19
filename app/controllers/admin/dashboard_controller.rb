class Admin::DashboardController < AdminController
  def index
    @financials = {}
    Competition::PRICING_MODELS.each_key do |handle|
      @financials[handle] = FinancialService.new(current_competition, PricingModel.for_handle(handle))
    end

    @counter = FinancialService.new(current_competition)

    @events_with_limits = current_competition.events.with_max_number_of_registrations.to_a
    @getting_started = getting_started

    @statistics = CompetitorStatistics.new(current_competition)
  end

  private

  def getting_started
    tips = []
    tips << :email if current_competition.email_templates.empty?
    tips << :events if current_competition.events.for_competitors_table.empty?
    tips << :theme if current_competition.theme_files.empty?
    tips << :users if current_competition.users.active.empty?
    tips += getting_started_owner_tips
    tips
  end

  def getting_started_owner_tips
    tips = []

    if current_competition.owner.blank?
      tips << :owner
    elsif current_competition.owner.address.blank?
      tips << :owner_without_address
    end

    tips
  end
end
