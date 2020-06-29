# rubocop:disable Metrics/LineLength
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.7.1'
# ruby-gemset=stimulus_cable_ready

gem 'autoprefixer-rails'
gem 'flutie'
gem 'jquery-rails'
gem 'normalize-rails', '~> 3.0.0'
gem 'pg'

gem 'rack-canonical-host'
gem 'rails', '>= 6'
gem 'recipient_interceptor'
gem 'redis-namespace'
gem 'sass-rails', '~> 5.0'
gem 'sassc', '2.2.0'
gem 'sidekiq'
gem 'simple_form'
gem 'sprockets', '>= 3.0.0'
gem 'webpacker', '~> 5.0'
gem 'title'
gem 'uglifier'

# Customizations
gem 'active_link_to'
gem 'browser'
gem 'dalli'
gem 'font-awesome-rails'
gem 'foundation-rails'
gem 'high_voltage'
gem 'kaminari'
gem 'rollbar', git: 'https://github.com/rollbar/rollbar-gem.git'
gem 'rpush'
gem 'slim-rails'

# Javascript Tweaks
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'
gem 'nprogress-rails' # Show request progress when a link is clicked
gem 'responders' # respond to json/html/js more easily in controllers
gem 'turbolinks'

# Authentication / Authorization
gem 'canard', git: 'https://github.com/headwayio/canard.git', branch: 'upgrade/rails-6' # ties into cancancan, adds roles for the user
gem 'cancancan' # authorization library
gem 'devise'
gem 'devise_invitable'
gem 'pretender' # impersonate users as an admin

# API / JSON
gem 'jsonapi-utils'
gem 'tiddle', git: 'https://github.com/adamniedzielski/tiddle.git'

# Administrative panel
gem 'administrate'
gem 'administrate-field-boolean_to_yes_no', git: 'https://github.com/headwayio/administrate-field-boolean_to_yes_no', branch: 'upgrade/rails-6'
gem 'administrate-field-collection_select', git: 'https://github.com/headwayio/administrate-field-collection_select', branch: 'feature/rails-6'
gem 'administrate-field-enum'
gem 'administrate-field-hex_color_picker', git: 'https://github.com/headwayio/administrate-field-hex_color_picker', branch: 'master'
gem 'administrate-field-nested_has_many'
gem 'administrate-field-password', git: 'https://github.com/DisruptiveAngels/administrate-field-password'
gem 'administrate-field-shrine', github: 'headwayio/administrate-field-shrine', branch: 'headway_master'
gem 'administrate-field-trix', git: 'https://github.com/headwayio/administrate-field-trix.git'
gem 'trix', github: 'headwayio/trix', branch: 'rails_5_2'

# Database Tweaks
gem 'active_model_serializers', '~> 0.10.0'
gem 'dynamic_form' # for custom messages without the database column
gem 'friendly_id' # slugs in the url auto-generated
gem 'nested_form_fields' # Dynamically add and remove nested has_many association fields in a Ruby on Rails form
# gem 'nondestructive_migrations' # data migrations go here, not in regular ActiveRecord migrations
gem 'nondestructive_migrations'
gem 'paranoia' # soft-delete by default
gem 'settingslogic' # yaml settings (project wide, non-editable), this is implemented with the model Settings.rb

# User Uploads
gem 'aws-sdk-s3', '~> 1.2' # for Amazon S3 storage
gem 'image_processing'
gem 'mini_magick'
gem 'shrine'

# Cron Jobs
# gem 'whenever', require: false # provides a clear syntax for writing and deploying cron jobs
# gem 'whenever-web'

# Debugging (need at top level if we want pry-remote to work on a deployed prod server)
gem 'pry-awesome_print' # make pry output legible
gem 'pry-byebug' # stepwise debugging inside pry
gem 'pry-rails' # better REPL than irb
gem 'pry-remote' # Production debugging

gem 'newrelic_rpm'

group :development do
  gem 'listen'
  gem 'spring'
  gem 'web-console'

  # Customizations
  gem 'annotate' # annotate models automatically when rake db:migrate is called
  gem 'fix-db-schema-conflicts' # when working with multiple developers schema order of columns is standardized.
  gem 'meta_request' # for chrome rails console plugin found here: https://chrome.google.com/webstore/detail/railspanel/gjpfobpafnhjhbajcjgccbbdofdckggg?hl=en-US
  gem 'rails-erd' # auto gen ERD Diagram of models in the app on rake db:migrate
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'awesome_print'
  gem 'bundler-audit', '>= 0.5.0', require: false
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 3.6'

  gem 'cucumber-rails', require: false

  # Customizations
  gem 'airborne'
  gem 'bullet'
  gem 'factory_bot_rails'
  gem 'letter_opener' # auto-open emails when they're sent
  gem 'refills'
  gem 'rubocop'
  gem 'rubocop-rspec', require: false
end

group :development, :staging do
  gem 'rack-mini-profiler', require: false
end

group :test do
  gem 'chronic'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'formulaic'
  gem 'launchy'
  gem 'pickle'
  gem 'pickler', git: 'https://github.com/headwayio/pickler', branch: 'feature/support_comments_after_linebreak' # , path: '/rails/headway/pickler'"
  gem 'show_me_the_cookies'
  gem 'simplecov', require: false
  gem 'site_prism'
  gem 'timecop'
  gem 'webmock'

  # Customizations
  gem 'cadre' # highlights code coverage in vim
  gem 'capybara' # DSL for finding elements on a page during integration testing
  gem 'capybara-selenium'
  gem 'chromedriver-helper'
  gem 'json-schema' # Allows testing API responses against JSON schema
  gem 'rspec_junit_formatter' # Creates JUnit style XML for use in CircleCI
  gem 'selenium-webdriver' # `brew install chromedriver`, used for acceptance tests in an actual browser.
  gem 'shoulda-matchers'
end

group :development, :test, :staging do
  gem 'faker' # provides auto generated names for factories, can be customized
end

group :staging, :production do
  gem 'rack-timeout'
end

group :production do
  gem 'analytics-ruby', '~> 2.2.2', require: 'segment/analytics'
  gem 'puma'
end

# Locking Dependenies
gem 'ffi', '1.9.25'

# rubocop:enable Metrics/LineLength

gem "stimulus_reflex", "~> 3.2"
