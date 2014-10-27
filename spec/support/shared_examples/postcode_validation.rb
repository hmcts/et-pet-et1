RSpec.shared_examples 'Postcode validation' do |options|
  describe 'validating a postcode' do
    subject { described_class.new }

    let(:prefix) { options[:attribute_prefix] }
    let(:errors) { subject.errors[:"#{prefix}_post_code"] }

    context 'when no postcode' do
      before do
        subject.send :"#{prefix}_post_code=", ''
        subject.valid?
      end

      it 'does not add any errors' do
        expect(errors).not_to include 'is invalid'
      end
    end

    context 'when it is not a valid postcode' do
      before do
        subject.send :"#{prefix}_post_code=", 'LOLZ'
        subject.valid?
      end

      it 'adds an error to the postcode attribute' do
        expect(errors).to include "is invalid"
      end
    end

    context 'when it is not a full postcode' do
      before do
        subject.send :"#{prefix}_post_code=", 'W1A'
        subject.valid?
      end

      it 'adds an error to the postcode attribute' do
        expect(errors).to include "is invalid"
      end
    end


    context 'when it is a full, valid postcode' do
      before do
        subject.send :"#{prefix}_post_code=", 'W1A 1AA'
        subject.valid?
      end

      it 'does not add any errors' do
        expect(errors).to be_empty
      end
    end
  end
end
