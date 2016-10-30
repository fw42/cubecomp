require File.expand_path('../config/application', __FILE__)
require "rake/testtask"

Rails.application.load_tasks

if %w(development test).include?(Rails.env)
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  task default: [:test, :rubocop]
end

task :audit do
  system('bundle exec bundle-audit update')
  system('bundle exec bundle-audit')
end
