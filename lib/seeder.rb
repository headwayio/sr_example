# rubocop:disable Rails/Output
module Seeder
  module_function

  def users
    puts '-----> Resetting to a clean user list with all Users'

    User.with_deleted.each(&:really_destroy!)
    FactoryBot.create(:user, :admin, email: 'admin@example.com')

    avatar = Rails.root.join('spec', 'fixtures', 'avatar.svg')

    (1..10).each do |i|
      FactoryBot.create(
        :user,
        email: "user#{i}@example.com",
        photo: fixture_file_upload(avatar, 'image/svg'),
      )
    end
  end
end

# rubocop:disable Metrics/LineLength
# :nocov:
if Rails.env.production?
  unless ENV['FORCE_SEED']
    puts
    puts '================================================================================='
    puts 'WARNING: You are trying to run db:seed on production. This is a DESTRUCTIVE task.'
    puts 'If you know what you are doing, you can override by setting environment variable '
    puts 'FORCE_SEED=1'
    abort('Exiting now...')
  end
end
# :nocov:
# rubocop:enable Rails/Output, Metrics/LineLength
