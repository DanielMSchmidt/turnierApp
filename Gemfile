source 'https://rubygems.org'

gem 'rails'

gem 'will_paginate', '~> 3.0'
gem 'puma' #faster webserver
gem 'foreman'
gem 'haml'
gem 'simple_form'
gem 'devise'
gem 'bootstrap-sass'
gem 'mechanize'
gem 'nokogiri'
gem 'libv8', '~> 3.11.8'
gem 'turbolinks'
gem 'jquery-turbolinks'

group :production do
  gem "newrelic_rpm", "~> 3.5.5.38"
  gem 'pg'
end

group :development do
  gem "rails_best_practices"

  #improving errorhandling
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'

  #html.erb to haml
  gem 'haml-rails'
  gem 'hpricot'
  gem 'ruby_parser'
end

group :development, :test do
  gem 'sqlite3'
  gem 'bullet'
  gem 'brakeman'

  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-cucumber'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'

  gem "rspec-rails", "~> 2.0"
  gem "factory_girl_rails"
  gem "capybara"
  gem 'shoulda-matchers'
  gem 'shoulda-context'
  gem 'factory_girl_rails'
  gem "nyan-cat-formatter"
  gem 'simplecov', :require => false
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'compass-rails'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
