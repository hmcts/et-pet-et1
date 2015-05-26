require "rails_helper"

describe BaseMailer, type: :mailer do
  include ClaimsHelper
  include Messages
  include MailMatchers

  def table_heading(heading)
    I18n.t("base_mailer.confirmation_email.details.#{heading}")
  end

  include_context 'block pdf generation'

  let(:claim) { create(:claim, :with_pdf, email_address: email_address) }
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

    it "has a subject" do
      expect(email.subject).to eq "Employment tribunal: complete your claim"
    end

    it 'has reference in body' do
      expect(email).to match_pattern claim.reference
    end
  end

  describe '#confirmation_email' do
    let(:email_addresses) { ['bill@example.com', 'mike@example.com'] }
    let(:attachment) { email.parts.find(&:filename) }

    subject { described_class.confirmation_email(claim) }

    before do
      claim.confirmation_email_recipients = email_addresses
      allow(claim).to receive(:payment_applicable?).and_return false
      allow(claim).to receive(:remission_applicable?).and_return false
    end

    context "post delivery" do
      it 'has been delivered' do
        email
        expect(ActionMailer::Base.deliveries).to be_present
      end

      it "has a subject" do
        expect(email.subject).to eq "Employment tribunal: claim submitted"
      end

      it 'has recipients' do
        expect(email.to).to eq email_addresses
      end

      it 'has reference in the body' do
        expect(email).to match_pattern claim.reference
      end

      it 'has office' do
        expect(email).
          to match_pattern 'Birmingham, Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU'
      end

      it 'has an attachment' do
        expect(attachment.filename).to eq('et1_barrington_wrigglesworth.pdf')
      end

      context 'when no office' do
        before { claim.office = nil }

        it 'does not show office details' do
          expect(email).not_to match_pattern 'to tribunal office'
        end
      end

      context 'when paid' do
        before do
          allow(claim).to receive(:fee_to_pay?).and_return(true)
        end

        it 'shows paid message' do
          expect(email).to match_pattern('Thank you for submitting')
          expect(email).to match_pattern('Issue fee paid:')
        end

        it 'shows amount paid' do
          expect(email).to match_pattern '£250.00'
        end
      end

      context 'when applying for remission' do
        before do
          allow(claim).to receive(:remission_applicable?).and_return true
          allow(claim).to receive(:payment_applicable?).and_return false
        end

        it 'shows remission help' do
          expect(email).to match_pattern(/complete fee remission application/i)
        end

        it 'does not show any payment information' do
          expect(email).not_to match_pattern payment_message
          expect(email).not_to match_pattern table_heading('fee_paid')
          expect(email).not_to match_pattern table_heading('fee_to_pay')
        end
      end

      context 'when payment failed' do
        let(:fee_calculation) do
          instance_double(ClaimFeeCalculator::Calculation, application_fee: 100, fee_to_pay?: true)
        end

        before do
          claim.payment = nil

          allow(claim).to receive(:payment_applicable?).and_return true
          allow(claim).to receive(:fee_calculation).and_return fee_calculation
        end

        it 'shows the intro for payment failure' do
          expect(email).
            to match_pattern 'we weren’t able to process your payment'
        end

        it 'explains payment was unsuccessful' do
          expect(email).to match_pattern 'Unable to process payment'
        end

        it 'does not show outstanding fee' do
          expect(email).to_not match_pattern '£250.00'
        end
      end
    end
  end
end
