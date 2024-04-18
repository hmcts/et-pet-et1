require 'rails_helper'
module Refunds
  RSpec.describe ReviewForm, type: :form do
    let!(:session_attributes) { attributes_for(:refund) }
    let!(:refund_instance) { build(:refund, session_attributes) }
    let!(:refund_class) { class_double(Refund).as_stubbed_const }
    let(:refund_attributes) { { accept_declaration: true } }
    let(:refund_session) { spy('Session', session_attributes.merge(to_h: session_attributes)) }
    let(:form) { described_class.new(refund_session) }

    context 'standard form behavior' do
      before do
        allow(refund_class).to receive(:new).and_return refund_instance
      end

      it_behaves_like 'a Form', { accept_declaration: true }, Session
    end

    describe 'validations' do
      before do
        allow(refund_class).to receive(:new).with(session_attributes).and_return(refund_instance)
      end

      context 'accept_declaration' do
        it 'validates acceptance of' do
          expect(form).to validate_acceptance_of(:accept_declaration)
        end
      end
    end

    describe 'callbacks' do
      before do
        allow(refund_class).to receive(:new).with(session_attributes).and_return refund_instance
      end

      it 'request the model generates application reference before save' do
        expect(refund_instance).to receive(:generate_application_reference)
        form.save
      end

      it 'request the model generates submitted date before save' do
        expect(refund_instance).to receive(:generate_submitted_at)
        form.save
      end
    end

    describe 'attributes' do
      before do
        allow(refund_class).to receive(:new).with(session_attributes).and_return refund_instance
      end

      let(:refund_instance) { build(:refund, created_at: DateTime.parse('1 December 2012 00:00:00').utc) }

      it 'provides read only proxy to underlying target' do
        expect(form.created_at.strftime('%F %R')).to eql '2012-12-01 00:00'
      end
    end
  end
end
