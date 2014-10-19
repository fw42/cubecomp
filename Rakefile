# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

more_test_dirs = %w(services patches liquid)

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :test do
  more_test_dirs.each do |test_dir|
    Rails::TestTask.new(test_dir => 'test:prepare') do |t|
      t.pattern = "test/#{test_dir}/**/*_test.rb"
    end
  end
end

more_test_dirs.each do |test_dir|
  Rake::Task[:test].enhance(["test:#{test_dir}"])
end

if %w(development test).include?(Rails.env)
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  task default: [:test, :rubocop]
end

task :audit do
  system("bundle exec bundle-audit update")
  system("bundle exec bundle-audit")
end
