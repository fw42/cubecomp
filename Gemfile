source 'https://rubygems.org'

gem 'mysql2'
gem 'rails'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'

# Make sure that sb-admin-2 and jquery-nested-attributes still
# work before version-bumping jQuery
gem 'jquery-rails', '~> 4.2.2'
gem 'jquery-turbolinks'

gem 'faraday'

gem 'turbolinks'
gem 'bcrypt'
gem 'codemirror-rails'

gem 'auto_strip_attributes'
gem 'marginalia'
gem 'liquid'

gem 'paperclip'

gem 'dotenv-rails'

group :test do
  gem 'mocha'
  gem 'timecop'
  gem 'webmock'
end

group :development do
  gem 'letter_opener'
end

group :development, :test do
  gem 'immigrant'
  gem 'forgery'

  gem 'consistency_fail'
  gem 'byebug'
  gem 'brakeman'
  gem 'spring'
  gem 'rubocop'
  gem 'bundler-audit'
end

group :deploy do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
end

group :production do
  gem 'unicorn'
  gem 'therubyracer'
  gem 'exception_notification'
end
