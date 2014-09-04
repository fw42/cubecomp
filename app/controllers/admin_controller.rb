class AdminController < ApplicationController
  layout 'admin'

  def current_user
    @current_user ||= begin
      User.first
    end
  end
  helper_method :current_user

  def current_competition
    @current_competition ||= begin
      if competition_id = params[:competition_id] || session[:competition_id]
        current_user.competitions.find(competition_id)
      else
        current_user.competitions.first
      end
    end
  end
  helper_method :current_competition

  def navigation_menu
    items = [
      {
        label: 'Competitions',
        controller: Admin::CompetitionsController,
        url: admin_competitions_path,
        css: 'fa-wrench'
      },
      {
        label: 'Dashboard',
        controller: Admin::DashboardController,
        url: admin_competition_dashboard_index_path(current_competition),
        css: 'fa-dashboard'
      },
      {
        label: 'Competitors',
        controller: Admin::CompetitorsController,
        url: admin_competition_competitors_path(current_competition),
        css: 'fa-list-alt'
      },
      {
        label: 'Events',
        controller: Admin::EventsController,
        url: admin_competition_events_path(current_competition),
        css: 'fa-table'
      },
      {
        label: 'News',
        controller: Admin::NewsController,
        url: admin_competition_news_index_path(current_competition),
        css: 'fa-files-o'
      }
    ]

    items.map do |options|
      options = options.merge(current_controller_instance: self)
      MenuItem.new(**options)
    end
  end
  helper_method :navigation_menu
end
