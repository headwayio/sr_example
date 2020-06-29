require 'active_record'

if ENV['CUCUMBER_PROFILE'] == 'syntastic'
  class User; end
  class DateOrderValidator
    def initialize(args); end
  end
end

module PickleDryRun
  rails_root = File.expand_path('../..', __dir__)
  all_models = Dir[File.join(rails_root, 'app', 'models', '**', '*.rb')]
  user_model = Dir[File.join(rails_root, 'app', 'models', 'user.rb')]
  the_models = all_models - user_model
  the_models.each { |l| require l }

  ActiveRecord::Base.establish_connection(
    adapter: 'postgresql',
    database: 'stimulus_cable_ready_test',
  )

  pickle_path = Bundler.rubygems.find_name('pickle').first.full_gem_path
  require "#{pickle_path}/lib/pickle"
  require "#{pickle_path}/lib/pickle/adapters/active_record"
  require "#{pickle_path}/lib/pickle/parser/matchers"
  require "#{pickle_path}/lib/pickle/email/parser"

  include Pickle
  include Pickle::Parser::Matchers
  include Pickle::Email::Parser

  def config
    Pickle.config
  end
end
