require "rails_helper"

describe BaseMailer do
  include ClaimsHelper
  include Messages

  let(:office) {
    Office.new(name: 'Birmingham', address: 'Phoenix House, 1-3 Newhall Street')
  }
  let(:claim) {
    Claim.create!(submitted_at: '2014-09-09', office: office, email_address: email_address)
  }
  let(:email_address) { 'mail@example.com' }
  let(:email) { subject.deliver_now }

  describe '#access_details_email' do
    subject { described_class.access_details_email(claim) }

    it 'has been delivered' do
      email
      expect(ActionMailer::Base.deliveries).to be_present
    end

    it 'has a recipient' do
      expect(email.to).to eq [email_address]
    end

    it 'has reference in body' do
      expect(email.body).to have_text claim.reference
    end
  end

  describe '#confirmation_email' do
    let(:email_addresses) { ['bill@example.com', 'mike@example.com'] }
    let(:content) { email.parts.find { |p| p.content_type.match(/html/) }.body.raw_source }
    let(:attachment) { email.parts.find(&:filename) }

    subject { described_class.confirmation_email(claim, email_addresses) }

    before do
      allow(claim).to receive(:payment_applicable?).and_return false
      allow(claim).to receive(:remission_applicable?).and_return false
      allow(claim).to receive(:pdf_filename).and_return "such.pdf"
      allow(claim).to receive(:pdf_file).and_return Tempfile.new('such.pdf')
    end

    context "pre delivery" do
      it 'attempts pdf generation on the claim' do
        expect(claim).to receive(:generate_pdf!)
        subject.deliver_now
      end
    end

    context "post delivery" do
      it 'has been delivered' do
        email
        expect(ActionMailer::Base.deliveries).to be_present
      end

      it 'has recipients' do
        expect(email.to).to eq email_addresses
      end

      it 'has reference in the body' do
        expect(content).to have_text claim.reference
      end

      it 'has office' do
        expect(content).to have_text 'Birmingham'
        expect(content).to have_text 'Phoenix House'
      end

      it 'has attachment' do
        expect(attachment.filename).to eq('such.pdf')
      end

      context 'when no office' do
        let(:office) { nil }

        it 'does not show office details' do
          expect(content).not_to have_text table_heading('office')
        end
      end

      context 'when paid' do
        before do
          claim.payment = Payment.new(amount: 100)
        end

        it 'shows paid message' do
          expect(content).
            to have_text "Thank you for your payment. We’ll write to you within 5 working days."
        end

        it 'shows amount paid' do
          expect(content).to have_text '100'
        end
      end

      context 'when applying for remission' do
        before do
          allow(claim).to receive(:remission_applicable?).and_return true
          allow(claim).to receive(:payment_applicable?).and_return false
        end

        it 'shows remission help' do
          expect(content).to have_text 'Get help with paying your fee'
        end

        it 'does not show any payment information' do
          expect(content).not_to have_text payment_message
          expect(content).not_to have_text table_heading('fee_paid')
          expect(content).not_to have_text table_heading('fee_to_pay')
        end
      end

      context 'when payment failed' do
        let(:fee_calculation) { double application_fee: 100 }

        before do
          allow(claim).to receive(:payment_applicable?).and_return true
          allow(claim).to receive(:fee_calculation).and_return fee_calculation
        end

        it 'does not show any paid information' do
          expect(content).not_to have_text payment_message
          expect(content).not_to have_text table_heading('fee_paid')
        end

        it 'shows outstanding fee' do
          expect(content).to have_text 'Fee to pay'
          expect(content).to have_text '100'
        end
      end
    end
  end
end
