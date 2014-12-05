class AdminController < ApplicationController
  layout 'admin'
  helper AdminMenuHelper
  before_action :ensure_authenticated
  before_action :current_competition
  before_action :ensure_current_competition

  def index
    redirect_to admin_competition_dashboard_index_path(current_competition)
  end

  private

  def ensure_current_competition
    return if current_competition
    redirect_to edit_admin_user_path(current_user)
  end

  def ensure_authenticated
    return if current_user
    redirect_to admin_login_path
  end

  def ensure_user_can_see_admin_menu
    return render_forbidden unless current_user.policy.admin_user_menu?
  end

  def render_not_found
    render text: 'not found', status: :not_found
  end

  def render_forbidden
    render text: 'forbidden', status: :forbidden
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
    @current_competition ||= begin
      competition = find_current_competition
      session[:competition_id] = competition.try(:id)
      competition
    end
  end
  helper_method :current_competition

  def find_current_competition
    competition = nil

    if competition_id = competition_id_from_params
      competition = current_competition_from_params(competition_id)
      return unless competition
    end

    competition ||= current_competition_from_session
    competition ||= current_user.policy.competitions.last
    competition
  end

  def competition_id_from_params
    return params[:id] if self.class == Admin::CompetitionsController
    params[:competition_id]
  end

  def current_competition_from_params(competition_id)
    competition = Competition.find(competition_id)

    unless current_user.policy.login?(competition)
      render_forbidden
      return
    end

    competition
  end

  def current_competition_from_session
    return unless competition_id = session[:competition_id]
    competition = Competition.find_by(id: competition_id)
    return unless competition
    return unless current_user.policy.login?(competition)
    competition
  end
end
