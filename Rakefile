# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :test do
  Rails::TestTask.new(services: "test:prepare") do |t|
    t.pattern = 'test/services/**/*_test.rb'
  end

  Rails::TestTask.new(patches: "test:prepare") do |t|
    t.pattern = 'test/patches/**/*_test.rb'
  end
end

Rake::Task[:test].enhance(['test:services'])
Rake::Task[:test].enhance(['test:patches'])
