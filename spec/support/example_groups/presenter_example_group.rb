module PresenterExampleGroup
  extend ActiveSupport::Concern

  included do
    metadata[:type] = :presenter
  end

  RSpec.configure do |config|
    config.include self,
      :type => :presenter,
      :file_path => %r(spec/presenters)
  end
end
