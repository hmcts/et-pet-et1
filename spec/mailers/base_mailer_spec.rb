require "rails_helper"

describe BaseMailer do
  include ClaimsHelper

  let(:office) { Office.new(name: 'Birmingham', address: 'Phoenix House, 1-3 Newhall Street')}
  let(:claim) { Claim.create!(submitted_at: '2014-09-09', office: office) }
  let(:email_address) { 'mail@example.com' }
  let(:email) { subject.deliver }

  def payment_message
    format I18n.t('claim_reviews.confirmation.fee_paid')
  end

  def remission_help
    format I18n.t('claim_reviews.confirmation.remission_help')
  end

  def table_heading(heading)
    I18n.t("claim_reviews.confirmation.details.#{heading}")
  end

  describe '#access_details_email' do
    subject { BaseMailer.access_details_email(claim, email_address) }

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
  end

  describe '#confirmation_email' do
    let(:email_addresses) { ['bill@example.com', 'mike@example.com'] }
    subject { BaseMailer.confirmation_email(claim, email_addresses) }

    before do
      allow(claim).to receive(:payment_applicable?).and_return false
      allow(claim).to receive(:remission_applicable?).and_return false
    end

    it 'has been delivered' do
      email
      expect(ActionMailer::Base.deliveries).to be_present
    end

    it 'has recipients' do
      expect(email.to).to eq email_addresses
    end

    it 'has reference in the body' do
      expect(email.body).to include claim.reference
    end

    it 'has office' do
      expect(email.body).to include 'Birmingham'
      expect(email.body).to include 'Phoenix House'
    end

    context 'when no office' do
      let(:office) { nil }

      it 'does not show office details' do
        expect(email.body).not_to include table_heading('office')
      end
    end

    context 'when paid' do
      before do
        claim.payment = Payment.new(amount: 100)
      end

      it 'shows paid message' do
        expect(email.body).to include payment_message
      end

      it 'shows amount paid' do
        expect(email.body).to include 100
      end
    end

    context 'when applying for remission' do
      before do
        allow(claim).to receive(:remission_applicable?).and_return true
        allow(claim).to receive(:payment_applicable?).and_return false
      end

      it 'shows remission help' do
        expect(email.body).to include remission_help
      end

      it 'does not show any payment information' do
        expect(email.body).not_to include payment_message
        expect(email.body).not_to include table_heading('fee_paid')
        expect(email.body).not_to include table_heading('fee_to_pay')
      end
    end

    context 'when payment failed' do
      let(:fee_calculation) { double application_fee: 100 }

      before do
        allow(claim).to receive(:payment_applicable?).and_return true
        allow(claim).to receive(:fee_calculation).and_return fee_calculation
      end

      it 'does not show any paid information' do
        expect(email.body).not_to include payment_message
        expect(email.body).not_to include table_heading('fee_paid')
      end

      it 'shows outstanding fee' do
        expect(email.body).to include table_heading('fee_to_pay')
        expect(email.body).to include 100
      end
    end
  end
end
