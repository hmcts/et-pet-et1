require 'rails_helper'
module Refunds
  RSpec.describe ReviewForm, type: :form do
    let(:refund_attributes) { { accept_declaration: true } }
    let(:refund) { instance_spy(Refund, refund_attributes) }
    let(:form) { described_class.new(refund) }

    it_behaves_like 'a Form', { accept_declaration: true }, Refund

    describe 'validations' do
      context 'accept_declaration' do
        it 'validates acceptance of' do
          expect(form).to validate_acceptance_of(:accept_declaration)
        end
      end
    end

    describe 'callbacks' do
      it 'request the model generates application reference before save' do
        expect(refund).to receive(:generate_application_reference)
        form.save
      end

      it 'request the model generates submitted date before save' do
        expect(refund).to receive(:generate_submitted_at)
        form.save
      end
    end

    describe 'attributes' do
      let(:refund_attributes) do
        {
          accept_declaration: true,
          created_at: DateTime.parse('1 December 2012 00:00:00').utc
        }
      end

      it 'provides read only proxy to underlying target' do
        expect(form.created_at).to eql DateTime.parse('1 December 2012 00:00:00').utc
      end
    end

  end
end
