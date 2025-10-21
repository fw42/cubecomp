source 'https://rubygems.org'

gem 'mysql2'
gem 'rails', '~> 6.1.7.9'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'execjs', '= 2.7.0'

gem 'rails-html-sanitizer', '>= 1.4.4'


# Make sure that sb-admin-2 and jquery-nested-attributes still
# work before version-bumping jQuery
gem 'jquery-rails', '>= 4.4.0'
gem 'jquery-turbolinks'

# suppress annoying warnings
# https://github.com/ruby/net-imap/issues/16#issuecomment-1321228565
gem 'net-http'
gem 'net-smtp'
gem 'net-imap', '>= 0.3.8'
gem "uri", ">= 0.12.4"

gem 'faraday'

gem 'turbolinks'
gem 'bcrypt'
gem 'codemirror-rails'

gem 'auto_strip_attributes'
gem 'marginalia'
gem 'liquid'

gem "nokogiri", ">= 1.18.3"
gem "kt-paperclip", "~> 6.4", ">= 6.4.1"

gem 'dotenv-rails'

group :test do
  gem 'mocha'
  gem 'timecop'
  gem 'webmock'
end

group :development do
  gem 'letter_opener'
  gem 'webrick', '~> 1.8.2'
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

  # https://github.com/net-ssh/net-ssh/issues/565
  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
end

group :production do
  gem 'unicorn'
  gem 'mini_racer'
  gem 'exception_notification'
end
