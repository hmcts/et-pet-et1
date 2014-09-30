module ValidatorExampleGroup
  extend ActiveSupport::Concern

  included do
    metadata[:type] = :validator
  end

  RSpec.configure do |config|
    config.include self,
      :type => :validator,
      :file_path => %r(spec/validators)
  end
end
