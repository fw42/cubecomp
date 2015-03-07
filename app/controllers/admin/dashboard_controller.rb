class Admin::DashboardController < AdminController
  def index
    @financials = FinancialService.new(current_competition)
  end
end
