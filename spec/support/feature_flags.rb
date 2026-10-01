RSpec.configure do |config|
  config.before do |example|
    next if example.metadata[:smoke]

    # Add any feature flags required by test suite here
  end
end
