if Rails.env.development? || Rails.env.test?
  require 'bundler/audit/task'
  Bundler::Audit::Task.new

  task default: 'bundle:audit'
end
