module JobExampleGroup
  extend ActiveSupport::Concern

  included do
    metadata[:type] = :job
  end

  RSpec.configure do |config|
    config.include self,
      :type => :job,
      :file_path => %r(spec/jobs)
  end
end
