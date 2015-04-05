source 'https://rubygems.org'

gem 'rails'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'

# Make sure that sb-admin-2 and jquery-nested-attributes still
# work before version-bumping jQuery
gem 'jquery-rails', '= 4.0.0'
gem 'jquery-turbolinks'

gem 'faraday'

gem 'turbolinks'
gem 'bcrypt'
gem 'codemirror-rails'
gem 'mysql2'

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
  gem 'quiet_assets'
  gem 'letter_opener'
  gem 'sqlite3'
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
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rails', '~> 1.1.2'
  gem 'capistrano-bundler', '~> 1.1.4'
  gem 'capistrano-rbenv', '~> 2.0.3'
end

group :production do
  gem 'unicorn'
  gem 'therubyracer'
  gem 'exception_notification'
end
