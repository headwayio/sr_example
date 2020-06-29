# rubocop:disable Metrics/LineLength, Rails/FilePath
require 'simplecov'
SimpleCov.command_name 'Rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path('../config/environment', __dir__)
abort('DATABASE_URL environment variable is set') if ENV['DATABASE_URL']

require 'spec_helper'
require 'rspec/rails'
require 'factory_bot'
require 'capybara/rspec'
require 'shoulda/matchers'
require 'database_cleaner'
require 'cadre/rspec3'
# require 'sidekiq/testing'
# require 'paperclip/matchers'

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |file| require file }

module Features
  # Extend this module in spec/support/features/*.rb
  include Formulaic::Dsl
end

RSpec.configure do |config|
  config.include Features, type: :feature # not sure what this does: https://github.com/thoughtbot/suspenders/issues/142
  config.infer_base_class_for_anonymous_controllers = false # not sure what this does: https://www.relishapp.com/rspec/rspec-rails/docs/controller-specs/anonymous-controller

  config.use_transactional_fixtures = false

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include RequestSpecHelper, type: :request
  config.include Features::SessionHelpers, type: :feature
  # config.include Paperclip::Shoulda::Matchers

  Capybara.asset_host = 'http://localhost:3000'

  # Can be used by passing driver: :selenium_chrome to a test
  Capybara.register_driver :selenium_chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  config.after do
    Capybara.current_driver = Capybara.default_driver
  end

  config.before do |spec|
    Capybara.current_driver = :selenium_chrome if spec.metadata[:browser]

    # Sidekiq::Testing.fake!
    # # This runs jobs immediately in the same thread
    # Sidekiq::Testing.inline! if spec.metadata[:inline]
  end

  # config.before(:suite) do
  #   # Load seed data to bootstrap the app with things the real app will have at
  #   # launch like States, roles, etc.
  #   require 'rake'
  #   HeadwayRailsTemplate::Application.load_tasks
  #   Rake::Task['db:seed'].invoke
  # end

  config.after do
    if Rails.env.test? || Rails.env.cucumber?
      FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
    end
  end

  # Cadre (code coverage)
  config.add_formatter(Cadre::RSpec3::NotifyOnCompleteFormatter)
  config.add_formatter(Cadre::RSpec3::QuickfixFormatter)
end

# RSpec::Sidekiq.configure do |config|
#   # Clears all job queues before each example
#   config.clear_all_enqueued_jobs = true # default => true

#   # Whether to use terminal colours when outputting messages
#   config.enable_terminal_colours = true # default => true

#   # Warn when jobs are not enqueued to Redis but to a job array
#   config.warn_when_jobs_not_processed_by_sidekiq = true # default => true
# end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
# rubocop:enable Metrics/LineLength, Rails/FilePath
