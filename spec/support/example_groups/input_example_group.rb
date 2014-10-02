module InputExampleGroup
  extend ActiveSupport::Concern

  included do
    metadata[:type] = :input
  end

  RSpec.configure do |config|
    config.include self,
      :type => :input,
      :file_path => %r(spec/inputs)
  end
end
