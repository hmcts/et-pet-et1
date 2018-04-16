require 'fog/aws'
require 'carrierwave/storage/fog'
CarrierWave.configure do |config|
  credentials = {
    provider:              'AWS',
    region:                ENV.fetch('AWS_REGION', 'eu-west-1'),
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'] || '',
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] || ''
  }

  credentials.merge!(endpoint: ENV['AWS_ENDPOINT'], host: URI.parse(ENV['AWS_ENDPOINT']).host) if ENV.key?('AWS_ENDPOINT')

  credentials[:path_style] = true if ENV.fetch('AWS_S3_FORCE_PATH_STYLE', 'false') == 'true'

  config.fog_public      = false
  config.fog_directory   = ENV['S3_UPLOAD_BUCKET']
  config.fog_credentials = credentials

  if Rails.env.test?
    Fog.mock!
    connection = Fog::Storage.new(credentials)
    connection.directories.create key: ENV['S3_UPLOAD_BUCKET']
  end
end
