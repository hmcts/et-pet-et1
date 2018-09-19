Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec

    # Choose one or more libraries:
    with.library :active_record
    with.library :active_model
    with.library :action_controller
  end
end
RSpec.configure do |config|
  config.include Shoulda::Matchers::ActiveModel, type: :form
  config.include Shoulda::Matchers::ActiveRecord, type: :form
end
