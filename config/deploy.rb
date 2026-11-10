set :application, 'cubecomp'
set :repo_url, 'git@github.com:fw42/cubecomp.git'

set :log_level, :info

set :linked_files, %w{config/database.yml .env}
set :linked_dirs, %w{log public/system tmp db/backup public/assets}

# Bundler 4 dropped the old `bundle config KEY VALUE` syntax; this makes
# capistrano-bundler use `bundle config set` instead
set :bundle_version, 4

namespace :deploy do
  # Full stop/start rather than a hot `upgrade` (USR2): a re-exec'd unicorn
  # master inherits the old process environment, so it keeps running the
  # previous Ruby version after an rbenv_ruby change. Costs a few seconds
  # of downtime.
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "RBENV_RUBY_VERSION=#{fetch(:rbenv_ruby)} #{current_path}/scripts/unicorn-init.sh restart"
    end
  end

  after :publishing, :restart
end
