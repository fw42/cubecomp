class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, ActionController::UnknownFormat, I18n::InvalidLocale do
    render_not_found
  end

  rescue_from RegistrationService::PermissionError do
    render_forbidden
  end

  before_action :set_locale_from_params

  def render_not_found
    render text: 'not found', status: :not_found
  end

  def render_forbidden
    render text: 'forbidden', status: :forbidden
  end

  private

  def set_locale_from_params
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
