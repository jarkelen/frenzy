CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider                         => 'Google',
    :google_storage_access_key_id     => 'GOOGVDPBZKSD4WGD3JNZ',
    :google_storage_secret_access_key => 'dvYO+GCKIhMwz4w4pEXOW5mEdOZYZ8hm3k99G7bH'
  }
  config.fog_directory = 'johnvanarkelen'
  config.cache_dir = "#{Rails.root}/tmp/uploads"
end