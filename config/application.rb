require File.expand_path('../boot', __FILE__)

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
    config.autoload_paths << Rails.root.join('app/liquid/drops')
    config.autoload_paths << Rails.root.join('app/liquid/filters')

    config.active_record.raise_in_transactional_callbacks = true

    config.wca_api_url = ENV["WCA_API_URL"]
  end
end
