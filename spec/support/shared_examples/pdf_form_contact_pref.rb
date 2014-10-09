RSpec.shared_examples 'it includes a contact preference' do |model_class, section|
  subject { described_class.new(model) }
  let(:hash) { subject.to_h }

  context 'when contact preference post' do
    let(:model) { model_class.new(contact_preference: 'post') }

    it 'ticks post' do
      expect(hash).to include("#{section} tick boxes" => 'post')
    end
  end

  context 'when contact preference email' do
    let(:model) { model_class.new(contact_preference: 'email') }

    it 'ticks email' do
      expect(hash).to include("#{section} tick boxes" => 'email')
    end
  end
end
