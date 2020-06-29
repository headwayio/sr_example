require 'simplecov'
SimpleCov.coverage_dir 'coverage/cucumber'
SimpleCov.start 'rails'

require 'selenium/webdriver'
require 'capybara/dsl'

require 'site_prism'
# SitePrism.use_implicit_waits = true

require 'email_spec'
require 'email_spec/cucumber'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu] },
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

Capybara.javascript_driver = :headless_chrome
Capybara.default_driver = :rack_test
Capybara.asset_host = 'http://localhost:3000'

Before('@javascript_debug') do
  Capybara.current_driver = :headless_chrome
end
After('@javascript_debug') do
  Capybara.use_default_driver
end

Before('@rack') do
  Capybara.current_driver = :rack_test
end
After('@rack') do
  Capybara.use_default_driver
end

# two ways to debug cukes
#
# 1) with a tag
After('@debug') do |scenario|
  save_and_open_page if scenario.failed? # rubocop:disable Lint/Debugger
end

# 2) with an env var (more useful for starting this way with guard)
After do |scenario|
  # rubocop:disable Lint/Debugger
  save_and_open_page if scenario.failed? && (ENV['DEBUG'] == 'open')
  # rubocop:enable Lint/Debugger
end

Before('@browser') do
  Capybara.current_driver = :selenium
end
After('@browser') do
  Capybara.use_default_driver
end

# Update cuke steps html file with step definitions
# Run the script each time before the suite starts
`ruby #{Rails.root}/features/support/cuke_steps.rb`

Chronic.time_class = Time.zone
