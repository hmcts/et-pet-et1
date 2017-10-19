require 'fog/aws'
CarrierWave.configure do |config|
  credentials = {
    provider:              'AWS',
    region:                ENV.fetch('AWS_REGION', 'eu-west-1'),
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'] || '',
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] || ''
  }

  config.fog_provider = 'fog/aws'
  if ENV.key?('AWS_ENDPOINT')
    credentials[:endpoint] = ENV['AWS_ENDPOINT']
    credentials[:host] = URI.parse(ENV['AWS_ENDPOINT']).host
  end

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
