module ServiceExampleGroup
  extend ActiveSupport::Concern

  included do
    metadata[:type] = :service
  end

  RSpec.configure do |config|
    config.include self,
      :type => :service,
      :file_path => %r(spec/services)
  end
end
