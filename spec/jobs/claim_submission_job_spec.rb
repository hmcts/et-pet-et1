require 'rails_helper'

describe ClaimSubmissionJob, type: :job do
  let(:claim)  { object_double Claim.new, confirmation_email_recipients?: false }
  let(:mailer) { instance_double Mail::Message, deliver: true }
  let(:claim_submission_job) { ClaimSubmissionJob.new }

  before do
    allow(BaseMailer).to receive(:confirmation_email).with(claim).and_return mailer
    allow(EtApi).to receive(:create_claim).with(claim, uuid: instance_of(String))
    allow(claim).to receive(:generate_pdf!)
  end

  describe '#perform' do
    it 'submits the claim' do
      expect(EtApi).to receive(:create_claim).with(claim, uuid: instance_of(String))
      claim_submission_job.perform(claim, SecureRandom.uuid)
    end

    it 'generates the pdf' do
      expect(claim).to receive(:generate_pdf!)
      claim_submission_job.perform(claim, SecureRandom.uuid)
    end

    describe 'sending confirmation email' do
      context 'when there are confirmation email recipients' do
        before do
          allow(claim).to receive(:confirmation_email_recipients?).and_return true
          allow(claim).to receive(:create_event).with 'confirmation_email_sent'
        end

        it 'sends the confirmation email' do
          expect(mailer).to receive(:deliver)
          claim_submission_job.perform(claim, SecureRandom.uuid)
        end

        it 'creates an email log event' do
          expect(claim).to receive(:create_event).with 'confirmation_email_sent'
          claim_submission_job.perform(claim, SecureRandom.uuid)
        end
      end

      context 'when there are no confirmation email recipients' do
        it 'does not send the confirmation email' do
          expect(mailer).not_to receive(:deliver)
          claim_submission_job.perform(claim, SecureRandom.uuid)
        end
      end
    end
  end
end
