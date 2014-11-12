module EPDQ
  def self.config(options = {})
    options.each { |k, v| send :"#{k}=", v }
  end
end

EPDQ.config pspid: ENV.fetch('EPDQ_PSPID'), sha_type: :sha256,
  sha_in: ENV.fetch('EPDQ_SECRET_IN'), sha_out: ENV.fetch('EPDQ_SECRET_OUT'),
  test_mode: !Rails.env.production?
