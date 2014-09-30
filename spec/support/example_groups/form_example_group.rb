module FormExampleGroup
  extend ActiveSupport::Concern

  included do
    metadata[:type] = :form
  end

  RSpec.configure do |config|
    config.include self,
      :type => :form,
      :file_path => %r(spec/forms)
  end
end
