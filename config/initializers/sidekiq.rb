redis_namespace = 'stimulus_cable_ready'
sidekiq_config = if ENV['REDIS_URL']
                   { url: ENV['REDIS_URL'], namespace: redis_namespace }
                 else
                   { namespace: redis_namespace }
                 end

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
