CarrierWave.configure do |config|
  properties = "#{Rails.root}/config/carrierwave.yml"
  YAML.load_file(properties)[Rails.env].each { |k, v| config.send "#{k}=", v }

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
