if Rails.env.development? || Rails.env.test?
  require 'factory_bot'

  namespace :dev do
    desc 'Sample data for local development environment'
    task prime: 'db:setup' do
      include FactoryBot::Syntax::Methods

      User.destroy_all

      create(:user, :admin)
      create(:user)
    end
  end
end
