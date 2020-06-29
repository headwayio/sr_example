namespace :rpush do
  task setup_ios_development: :environment do
    app = Rpush::Apns::App.new
    app.name = 'ios_app'
    app.certificate = File.read('/path/to/sandbox.pem')
    app.environment = 'development' # APNs environment.
    app.connections = 1
    app.save!
  end

  task setup_ios_production: :environment do
    app = Rpush::Apns::App.new
    app.name = 'ios_app'
    app.certificate = File.read('/path/to/production.pem')
    app.environment = 'production' # APNs environment.
    app.connections = 1
    app.save!
  end

  task setup_android_development: :environment do
  end
end
