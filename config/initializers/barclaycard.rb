module EPDQ
  def self.config(options = {})
    options.each { |k, v| send :"#{k}=", v }
  end
end

EPDQ.config pspid: ENV['EPDQ_PSPID'],
            sha_type: :sha256,
            sha_in: ENV['EPDQ_SECRET_IN'],
            sha_out: ENV['EPDQ_SECRET_OUT'],
            test_mode: ENV['ENV'] == 'prod' ? false : true
