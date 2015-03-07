class Admin::DashboardController < AdminController
  def index
    @financials = FinancialService.new(current_competition)
    @events_with_limits = current_competition.events.with_max_number_of_registrations.to_a
    @getting_started = getting_started
  end

  private

  def getting_started
    tips = []
    tips << :events if current_competition.events.for_competitors_table.empty?
    tips << :owner if current_competition.owner.blank?
    tips << :theme if current_competition.theme_files.empty?
    tips << :users if current_competition.users.empty?
    tips
  end
end
