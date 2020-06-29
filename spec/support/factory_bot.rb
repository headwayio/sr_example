RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Spring doesn't reload factory_bot
  config.before(:all) do
    FactoryBot.reload
  end
end
