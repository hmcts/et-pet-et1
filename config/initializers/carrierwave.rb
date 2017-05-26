CarrierWave.configure do |config|
  credentials = {
    provider:              'AWS',
    region:                'eu-west-1',
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'] || '',
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] || ''
  }

  config.storage (Rails.env.development?)? :file : :fog
  config.fog_public      = false
  config.fog_directory   = ENV['S3_UPLOAD_BUCKET']
  config.fog_credentials = credentials

  if Rails.env.test?
    Fog.mock!
    connection = Fog::Storage.new(credentials)
    connection.directories.create key: ENV['S3_UPLOAD_BUCKET']
  end
end
