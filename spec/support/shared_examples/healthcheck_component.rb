RSpec.shared_examples 'a healthcheck component' do
  describe '.available?' do
    it 'creates an instance & calls available? on it' do
      allow_any_instance_of(described_class).to receive(:available?).and_return true
      expect(described_class.available?).to be_truthy
    end

    it 'returns false if an error is raised' do
      allow_any_instance_of(described_class).to receive(:available?).and_raise('fail lolz')
      expect(described_class.available?).to be_falsey
    end
  end
end
