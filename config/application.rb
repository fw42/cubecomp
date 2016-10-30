require_relative 'boot'

require 'rails/all'
Bundler.require(*Rails.groups)

module Cubecomp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    config.i18n.default_locale = :en

    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app')
    config.autoload_paths << Rails.root.join('app/liquid/drops')
    config.autoload_paths << Rails.root.join('app/models/concerns')

    config.active_record.raise_in_transactional_callbacks = true

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
