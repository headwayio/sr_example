JSONAPI.configure do |config|
  config.json_key_format = :underscored_key
  config.route_format = :underscored_route

  config.top_level_meta_include_record_count = true
  config.top_level_meta_record_count_key = :record_count

  config.resource_cache = Rails.cache
end
