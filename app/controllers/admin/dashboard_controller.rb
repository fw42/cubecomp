class Admin::DashboardController < AdminController
  def index
    @financials = FinancialService.new(current_competition)
    @events_with_limits = current_competition.events.with_max_number_of_registrations.to_a
  end
end
