require 'faker'
require 'factory_bot_rails'

# ensure Spring has the latest version of the factories
FactoryBot.reload

# Allow factories to be created with just create(:user) instead of
# FactoryBot.create(:user)
World(FactoryBot::Syntax::Methods)
