source 'http://rubygems.org'

gem 'rails',              '~>3.2.11'
gem 'pg',                 '~>0.14.1'

# Add new gems here
gem 'nokogiri',           '~>1.5.6'
gem 'awesome_print',      '~>1.1.0'
gem 'will_paginate',      '~>3.0.4'
gem 'konf',               '~>0.0.2'

# Using Postgresql now, so might not need geokit. 
# But, might be useful if I want a Geocoder in the future.
# https://github.com/jlecour/geokit-rails3
# gem 'geokit-rails3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'libv8',            '3.11.8.0'
  gem 'therubyracer',     '0.11.0beta8'
  gem 'bootstrap-sass',   '~> 2.2.2.0'
  gem 'sass-rails',       '~> 3.2.6'
  gem 'coffee-rails',     '~> 3.2.2'
  gem 'uglifier',         '>= 1.3.0'
end

gem 'haml',               '~>3.1.7'
gem 'jquery-rails',       '~>2.2.0'
gem 'jbuilder',           '~>1.0.2'

# Deploy with Capistrano
gem 'capistrano',         '~>2.14.1'
gem 'capistrano-ext'
gem 'rvm-capistrano'

# Site monitoring/errors
gem 'newrelic_rpm',       '~>3.5.6.46'
gem "airbrake",           '~>3.1.7'

# SEO
gem 'sitemap_generator',  '~> 3.4'

# Cron Job Management
gem 'whenever',           '~>0.8.2', :require => false

# To use debugger
# gem 'ruby-debug19'#, :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', '~> 0.9.6'#, :require => false
  # https://github.com/thoughtbot/factory_girl_rails
  gem 'factory_girl_rails'
end
