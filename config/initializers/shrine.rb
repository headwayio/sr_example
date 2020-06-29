require 'shrine'
require 'shrine/storage/file_system'

require 'shrine'
if ENV['S3_BUCKET'].blank?
  require 'shrine/storage/file_system'
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store'),
  }
else
  require 'shrine/storage/s3'
  s3_options = {
    access_key_id:     ENV['S3_ACCESS_KEY_ID'],
    secret_access_key: ENV['S3_SECRET_ACCESS_KEY'],
    region:            ENV['S3_REGION'],
    bucket:            ENV['S3_BUCKET'],
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
    store: Shrine::Storage::S3.new(prefix: 'store', **s3_options),
  }
end
Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for forms
Shrine.plugin :presign_endpoint
Shrine.plugin :data_uri
Shrine.plugin :determine_mime_type
