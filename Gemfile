source 'https://rubygems.org'

gem 'rails', '~> 3.2.15'

gem 'puma' #faster webserver
gem 'foreman'
gem 'haml'

# UI
gem 'simple_form'
gem 'devise'
gem 'will_paginate', '~> 3.0'
gem 'bootstrap-sass', '~> 2.3.2.0'
gem 'bootstrap-datepicker-rails'

#Data fetching
gem 'mechanize'
gem 'nokogiri'

#Caching
gem 'redis-rails'

#PDF generation
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

#Tasks
gem 'whenever', :require => false
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', :require => nil

gem 'mysql2'

group :production do
  gem 'newrelic_rpm'

end

group :development do
  gem "rails_best_practices"
  gem 'i18n-tasks', '~> 0.0.8'

  gem "wkhtmltopdf", "~> 0.1.2"

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

  gem 'dotenv-rails'

  gem "rspec-rails", "~> 2.0"
  gem "factory_girl_rails"
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

  gem 'modernizr-rails'

  gem 'libv8'
  gem 'therubyracer', :platforms => :ruby, :require => 'v8'
  gem 'compass-rails'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'


# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano_colors'
gem 'capistrano-ext'
gem 'rvm-capistrano'
