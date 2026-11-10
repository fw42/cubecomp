require_relative 'boot'

require 'rails'
# Active Storage, Action Text, Action Mailbox and Action Cable are not used
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'
Bundler.require(*Rails.groups)

module Cubecomp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.active_record.time_zone_aware_types = [:datetime, :time]

    config.i18n.default_locale = :en

    # Annotate SQL queries with the controller/action that issued them
    # (formerly done by the marginalia gem)
    config.active_record.query_log_tags_enabled = true
    config.active_record.query_log_tags_format = :legacy
    config.active_record.query_log_tags = [ :application, :controller, :action, :job ]

    config.eager_load_paths << Rails.root.join('app/liquid/drops')

    # For security reasons, the admin area should be on a different
    # (sub)domain than the competition area, otherwise competition area
    # themes could potentially read admin session cookies.
    config.admin_domain = ENV["CUBECOMP_ADMIN_DOMAIN"]

    # All requests seen by this application, which are neither for the
    # main nor for the admin domain, will be redirected to the main domain
    config.main_domain = ENV["CUBECOMP_MAIN_DOMAIN"]
    # 'http://' or 'https://', wont redirect if left empty
    config.main_domain_protocol = ENV['CUBECOMP_MAIN_DOMAIN_PROTOCOL']

    # This will be used as asset host if set, e.g. https://assets.cubecomp.de/
    config.asset_host = ENV['CUBECOMP_ASSET_HOST']

    config.email_address = ENV["CUBECOMP_EMAIL"] || "cubecomp@cubecomp.de"

    config.github = "https://github.com/fw42/cubecomp"

    config.wca_api_url = ENV["CUBECOMP_WCA_API_URL"]

    # Sends exception emails to this address in the production environment
    config.exceptions_email = ENV["CUBECOMP_EXCEPTIONS_EMAIL"]

    # Browser API key for the Google Maps Embed API
    config.google_maps_api_key = ENV['CUBECOMP_GOOGLE_MAPS_API_KEY']
  end
end

Rails.application.configure do
  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  if Cubecomp::Application.config.asset_host.present?
    config.action_controller.asset_host = Cubecomp::Application.config.asset_host
  end
end
