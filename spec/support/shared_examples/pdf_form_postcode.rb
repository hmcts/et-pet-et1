RSpec.shared_examples 'it includes a formatted postcode' do |model_class, section|
  subject { described_class.new(model) }

  let(:hash) { subject.to_h }

  context 'when postcode specified' do
    let(:model) { model_class.new address_post_code: 'A9 9AA' }

    it 'includes formatted postcode' do
      expect(hash).to include("#{section} postcode" => 'A9  9AA')
    end
  end
end
