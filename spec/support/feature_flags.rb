RSpec.configure do |config|
  config.before do |example|
    next if example.metadata[:smoke]

    FeatureFlag.find_or_create_by(key: 'era_oct_26', default_value: true, name: 'ERA Oct 2026')
  end
end
