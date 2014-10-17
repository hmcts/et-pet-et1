require "rails_helper"

describe BaseMailer do
  include ClaimsHelper
  include Messages

  let(:office) { Office.new(name: 'Birmingham', address: 'Phoenix House, 1-3 Newhall Street')}
  let(:claim) { Claim.create!(submitted_at: '2014-09-09', office: office) }
  let(:email_address) { 'mail@example.com' }
  let(:email) { subject.deliver_now }

  describe '#access_details_email' do
    subject { described_class.access_details_email(claim, email_address) }

    it 'has been delivered' do
      email
      expect(ActionMailer::Base.deliveries).to be_present
    end

    it 'has a recipient' do
      expect(email.to).to eq [email_address]
    end

    it 'has reference in the subject' do
      expect(email.subject).to include claim.reference
    end

    it 'has reference in body' do
      expect(email.body).to include claim.reference
    end

    context 'when mailer raises exceptions' do
      before do
        Mail::Message.class_eval do
          alias_method :original_original_deliver, :original_deliver
          def original_deliver; raise Net::SMTPFatalError; end
        end
      end

      it 'logs and rescues' do
        expect(Rails.logger).to receive(:warn)
        email
      end

      after do
        Mail::Message.class_eval do
          alias_method :original_deliver, :original_original_deliver
        end
      end
    end

  end

  describe '#confirmation_email' do
    let(:email_addresses) { ['bill@example.com', 'mike@example.com'] }
    subject { described_class.confirmation_email(claim, email_addresses) }
    let(:content) { email.parts.find {|p| p.content_type.match /html/ }.body.raw_source }
    let(:attachment) { email.parts.find {|p| p.filename == 'filename' }.body.raw_source }

    before do
      allow(claim).to receive(:payment_applicable?).and_return false
      allow(claim).to receive(:remission_applicable?).and_return false
      pdf_form = double filename: 'filename', to_pdf: 'pdf'
      allow(PdfFormBuilder).to receive(:new).with(claim).and_return pdf_form
    end

    it 'has been delivered' do
      email
      expect(ActionMailer::Base.deliveries).to be_present
    end

    it 'has recipients' do
      expect(email.to).to eq email_addresses
    end

    it 'has reference in the body' do
      expect(content).to include claim.reference
    end

    it 'has office' do
      expect(content).to include 'Birmingham'
      expect(content).to include 'Phoenix House'
    end

    it 'has attachment' do
      expect(attachment).to eq('pdf')
    end

    context 'when no office' do
      let(:office) { nil }

      it 'does not show office details' do
        expect(content).not_to include table_heading('office')
      end
    end

    context 'when paid' do
      before do
        claim.payment = Payment.new(amount: 100)
      end

      it 'shows paid message' do
        expect(content).to include payment_message
      end

      it 'shows amount paid' do
        expect(content).to include '100'
      end
    end

    context 'when applying for remission' do
      before do
        allow(claim).to receive(:remission_applicable?).and_return true
        allow(claim).to receive(:payment_applicable?).and_return false
      end

      it 'shows remission help' do
        expect(content).to include remission_help
      end

      it 'does not show any payment information' do
        expect(content).not_to include payment_message
        expect(content).not_to include table_heading('fee_paid')
        expect(content).not_to include table_heading('fee_to_pay')
      end
    end

    context 'when payment failed' do
      let(:fee_calculation) { double application_fee: 100 }

      before do
        allow(claim).to receive(:payment_applicable?).and_return true
        allow(claim).to receive(:fee_calculation).and_return fee_calculation
      end

      it 'does not show any paid information' do
        expect(content).not_to include payment_message
        expect(content).not_to include table_heading('fee_paid')
      end

      it 'shows outstanding fee' do
        expect(content).to include table_heading('fee_to_pay')
        expect(content).to include '100'
      end
    end
  end
end
