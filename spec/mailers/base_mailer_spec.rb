# coding: utf-8
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
    subject { described_class.confirmation_email(claim) }

    let(:email_addresses) { ['bill@example.com', 'mike@example.com'] }
    let(:attachment) { email.parts.find(&:filename) }

    before do
      claim.confirmation_email_recipients = email_addresses
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
          to match_pattern "Birmingham, email@example.com, 0121 600 7780"
      end

      it 'has an attachment' do
        expect(attachment.filename).to eq('et1_barrington_wrigglesworth.pdf')
      end

      it "has what happen next step 1" do
        expect(email).
          to match_pattern ["contact you once we have sent your claim to the respondent and explain what happens next.",  "At present, this is taking us an of average of 25 days."]
      end

      it "has what happen next step 2" do
        expect(email).
          to match_pattern ['Once we have sent them your claim, the respondent has 28 days to reply.']
      end

      context 'when no office' do
        before { claim.office = nil }

        it 'does not show office details' do
          expect(email).not_to match_pattern 'to tribunal office'
        end
      end

      # @TODO Think about renaming this - nothing to do with payment anymore
      context 'when paid' do
        describe 'hide paid message' do
          it { expect(email).to match_pattern('Thank you for submitting') }
          it { expect(email).not_to match_pattern('Issue fee paid:') }
        end

        it 'hide amount paid' do
          expect(email).not_to match_pattern '£250.00'
        end
      end
    end

    context "Welsh post" do
      before { I18n.locale = :cy }

      it 'has been delivered' do
        email
        expect(ActionMailer::Base.deliveries).to be_present
      end

      it "has a subject" do
        expect(email.subject).to eq "Tribiwnlys Cyflogaeth: hawliad wedi'i gyflwyno"
      end

      it 'has recipients' do
        expect(email.to).to eq email_addresses
      end

      it 'has reference in the body' do
        expect(email).to match_pattern claim.reference
      end

      it 'has office' do
        expect(email).
          to match_pattern "Birmingham, email@example.com, 0121 600 7780"
      end

      it 'has an attachment' do
        expect(attachment.filename).to eq('et1_barrington_wrigglesworth.pdf')
      end

      it "has what happen next step 1" do
        expect(email).
          to match_pattern ["Fe anfonir copi o", "r hawliad at yr atebydd.", "Bydd ganddynt 28 diwrnod i ymateb."]
      end

      it "has what happen next step 2" do
        expect(email).
          to match_pattern ["Byddwn yn cysylltu â chi pan fyddwn wedi anfon eich hawliad at yr atebydd i","esbonio beth yw'r camau nesaf."]
      end

      context 'when no office' do
        before { claim.office = nil }

        it 'does not show office details' do
          expect(email).not_to match_pattern 'to tribunal office'
        end
      end
    end
  end
end
