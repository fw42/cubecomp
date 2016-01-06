set :application, 'cubecomp'
set :repo_url, 'git@github.com:fw42/cubecomp.git'

set :log_level, :info

set :linked_files, %w{config/database.yml .env}
set :linked_dirs, %w{log public/system tmp db/backup public/assets}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "RBENV_RUBY_VERSION=#{fetch(:rbenv_ruby)} #{current_path}/bin/unicorn-init.sh upgrade"
    end
  end

  after :publishing, :restart
end
