class ApplicationController < ActionController::Base
  class InvalidParametersError < StandardError; end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  not_found_exceptions = [
    ActiveRecord::RecordNotFound,
    ActionController::UnknownFormat,
    I18n::InvalidLocale
  ]

  forbidden_exceptions = [
    RegistrationService::PermissionError,
    InvalidParametersError
  ]

  rescue_from(*not_found_exceptions) do |exception|
    Rails.logger.error(exception)
    render_not_found
  end

  rescue_from(*forbidden_exceptions) do |exception|
    Rails.logger.error(exception)
    render_forbidden
  end

  around_action :switch_locale_from_params

  def render_not_found
    render plain: 'not found', status: :not_found
  end

  def render_forbidden
    render plain: 'forbidden', status: :forbidden
  end

  private

  def switch_locale_from_params(&action)
    I18n.with_locale(params[:locale] || I18n.default_locale, &action)
  end
end
