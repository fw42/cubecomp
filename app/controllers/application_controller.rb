class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, ActionController::UnknownFormat do
    render_not_found
  end

  def render_not_found
    render text: 'not found', status: :not_found
  end
end
