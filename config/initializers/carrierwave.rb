CarrierWave.configure do |config|
  credentials = {
    provider:              'AWS',
    region:                'eu-west-1',
    aws_access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
  }

  config.storage :fog
  config.fog_public      = false
  config.fog_directory   = ENV.fetch('S3_UPLOAD_BUCKET')
  config.fog_credentials = credentials

  unless Rails.env.production?
    Fog.mock!
    connection = Fog::Storage.new(credentials)
    connection.directories.create key: ENV.fetch('S3_UPLOAD_BUCKET')
  end
end
