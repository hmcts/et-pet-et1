RSpec.shared_examples 'a Form' do |attributes, resource_class_or_lambda = Claim, excluded_save_attributes = []|
  let(:resource_class) do
    if resource_class_or_lambda.respond_to?(:call)
      resource_class_or_lambda.call
    else
      resource_class_or_lambda
    end
  end
  let(:form) { described_class.new(resource_class.new) { |f| f.assign_attributes attributes } }

  describe '.model_name_i18n_key' do
    specify do
      expect(described_class.model_name_i18n_key).
        to eq(described_class.model_name.i18n_key)
    end
  end

  describe '#column_for_attribute' do
    it "returns the attribute's type"
  end

  describe '#save' do
    describe 'for valid attributes' do
      before { allow(form.target).to receive(:update) }

      it "saves the data" do
        expect(form.resource).to receive(:save)

        form.save

        expect(form.target).to have_received(:update).with form.attributes.except(*excluded_save_attributes)
      end
    end

    describe 'for invalid attributes' do
      before { allow(form).to receive(:valid?).and_return false }

      it 'is not saved' do
        expect(form.resource).not_to receive(:save)
        form.save
      end
    end

    context 'when target frozen (destroyed)' do
      before do
        allow(form).to receive(:valid?).and_return true
        allow(form.target).to receive(:frozen?).and_return true
      end

      it 'does not attempt to update the target' do
        expect(form.target).not_to receive(:update)
        expect(form.resource).to receive(:save)
        form.save
      end
    end
  end
end
