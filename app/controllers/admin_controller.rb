class AdminController < ApplicationController
  layout 'admin'
  before_action :ensure_authenticated
  before_action :set_current_competition
  before_action :ensure_current_competition

  rescue_from ActiveRecord::RecordNotFound do
    render_not_found
  end

  def index
    redirect_to admin_competition_dashboard_index_path(current_competition)
  end

  private

  def ensure_current_competition
    if current_competition.nil?
      redirect_to edit_admin_user_path(current_user)
    end
  end

  def ensure_authenticated
    if current_user.nil?
      redirect_to admin_login_path
    end
  end

  def render_not_found
    render text: 'not found', status: :not_found
  end

  def render_unauthorized
    render text: 'unauthorized', status: :unauthorized
  end

  def current_user
    @current_user ||= begin
      if session[:user_id]
        user = User.find_by(id: session[:user_id])
        reset_session if user.nil?
        user
      end
    end
  end
  helper_method :current_user

  def current_competition
    set_current_competition unless @current_competition
    @current_competition
  end
  helper_method :current_competition

  def set_current_competition
    competition_id = if self.class == Admin::CompetitionsController
      params[:id]
    else
      params[:competition_id]
    end

    competition = nil
    if competition_id
      competition = current_competition_from_params(competition_id)
      return unless competition
    end

    competition ||= current_competition_from_session(session[:competition_id]) if session[:competition_id]
    competition ||= current_user.policy.competitions.last

    session[:competition_id] = competition.try(:id)
    @current_competition = competition
  end

  def current_competition_from_session(competition_id)
    competition = Competition.find_by(id: session[:competition_id])

    if competition && !current_user.policy.login?(competition)
      return
    end

    competition
  end

  def current_competition_from_params(competition_id)
    competition = Competition.find(competition_id)

    if !current_user.policy.login?(competition)
      render_unauthorized
      return
    end

    competition
  end

  def admin_user_menu
    items = [
      {
        label: 'Competitions',
        controller: Admin::CompetitionsController,
        url: admin_competitions_path,
        css: 'fa-wrench'
      },
      {
        label: 'Users',
        controller: Admin::UsersController,
        url: admin_users_path,
        css: 'fa-user'
      },
      {
        label: 'Themes',
        controller: [ Admin::ThemesController, Admin::ThemeFileTemplatesController ],
        url: admin_themes_path,
        css: 'fa-files-o'
      }
    ]

    MenuItem.parse(self, items)
  end
  helper_method :admin_user_menu

  def navigation_menu
    items = [
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
        css: 'fa-star'
      },
      {
        label: 'Theme',
        controller: Admin::ThemeFilesController,
        url: admin_competition_theme_files_path(current_competition),
        css: 'fa-files-o'
      },
      {
        label: 'Settings',
        controller: Admin::CompetitionsController,
        actions: ['edit'],
        url: edit_admin_competition_path(current_competition),
        css: 'fa-wrench'
      }
    ]

    MenuItem.parse(self, items)
  end
  helper_method :navigation_menu
end
