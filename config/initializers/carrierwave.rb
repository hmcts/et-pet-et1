CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage                          :fog
    config.fog_public                       = false
    config.fog_directory                    = ENV.fetch('S3_UPLOAD_BUCKET')
    config.fog_credentials = {
      provider:              'AWS',
      region:                'eu-west-1',
      aws_access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
      aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
    }
  else
    config.storage :file
  end

  Dir["#{Rails.root}/app/uploaders/*.rb"].each { |file| require file }

  CarrierWave::Uploader::Base.descendants.each do |klass|
    klass.class_eval do
      def store_dir
        if Rails.env.test?
          "spec/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.reference}"
        else
          "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.reference}"
        end
      end
    end
  end
end
