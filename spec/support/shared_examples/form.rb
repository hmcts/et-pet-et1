RSpec.shared_examples 'a Form' do |attributes, block|
  let(:proxy)    { double 'proxy', first: nil, second: nil }
  let(:resource) { double 'resource' }
  let(:target)   { double 'target', update_attributes: nil }
  let(:form)     { described_class.new(attributes) { |f| f.resource = resource } }

  describe '.model_name_i18n_key' do
    specify do
      expect(described_class.model_name_i18n_key).
        to eq(described_class.model_name.i18n_key)
    end
  end

  describe '#column_for_attribute' do
    it 'delegates through to target resource' do
      expect(target).to receive(:column_for_attribute).with(:lol)
      allow(form).to receive(:target).and_return target

      form.column_for_attribute :lol
    end
  end

  describe '#save' do
    describe 'for valid attributes' do
      it "saves the data" do
        # Allow double to receive attributes that have validators. It will
        # receive those messages on save because the validators call through to
        # them and in turn the target receives the message if the attribute is
        # blank
        described_class.validators.flat_map(&:attributes).uniq.
          each { |a| allow(target).to receive(a) }

        instance_eval &block

        expect(form.resource).to receive(:save)

        form.save
        expect(target).to have_received(:update_attributes).with attributes.slice(*form.attributes.keys)
      end
    end

    describe 'for invalid attributes' do
      before { allow(form).to receive(:valid?).and_return false }

      it 'is not saved' do
        expect(resource).not_to receive(:save)
        form.save
      end
    end

    context 'when target destroyed' do
      before do
        allow(form).to receive(:valid?).and_return false
        allow(target).to receive(:frozen?).and_return true
        allow(resource).to receive(:save)
      end

      it 'does not attempt to update the target' do
        expect(target).not_to receive(:update_attributes)
        form.save
      end
    end
  end
end
