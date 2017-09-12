module CarrierWaveHelper
  def using_carrierwave_storage(storage)
    old_storage = CarrierWave::Uploader::Base.storage
    CarrierWave::Uploader::Base.storage = storage
    yield
    CarrierWave::Uploader::Base.storage = old_storage
  end
end
