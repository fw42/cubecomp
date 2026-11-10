# Puma configuration. Used by `bin/rails server` in development and by
# scripts/puma-init.sh in production.

if ENV.fetch('RAILS_ENV', 'development') == 'production'
  app_path = File.expand_path('..', __dir__)

  environment 'production'
  directory app_path

  # Same model as the previous unicorn setup: one single-threaded worker
  # process per CPU core, listening on localhost for nginx
  workers ENV.fetch('WEB_CONCURRENCY', 4).to_i
  threads 1, 1
  bind 'tcp://127.0.0.1:50000'

  pidfile "#{app_path}/tmp/puma.pid"
  stdout_redirect "#{app_path}/log/puma.log", "#{app_path}/log/puma.log", true
else
  threads_count = ENV.fetch('RAILS_MAX_THREADS', 5).to_i
  threads threads_count, threads_count
  port ENV.fetch('PORT', 3000)
  plugin :tmp_restart
end
