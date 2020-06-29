if ENV['ROLLBAR_ACCESS_TOKEN'].present?
  require 'rollbar'

  Rollbar.configure do |config|
    config.access_token = ENV.fetch('ROLLBAR_ACCESS_TOKEN')
    config.js_enabled = true
    config.js_options = {
      accessToken: ENV.fetch('ROLLBAR_CLIENT_ACCESS_TOKEN'),
      captureUncaught: true,
      payload: {
        environment: 'production',
      },
    }
  end
end
