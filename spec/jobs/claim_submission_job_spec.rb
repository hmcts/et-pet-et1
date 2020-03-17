require 'rails_helper'

describe ClaimSubmissionJob, type: :job do
  let(:claim)  { object_double Claim.new, confirmation_email_recipients?: false }
  let(:mailer) { instance_double Mail::Message, deliver: true }
  let(:claim_submission_job) { ClaimSubmissionJob.new }

  before do
    allow(EtApi).to receive(:create_claim).with(claim, uuid: instance_of(String))
    allow(claim).to receive(:generate_pdf!)
    allow(claim).to receive(:finalize!)
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

    it 'finalizes the claim' do
      expect(claim).to receive(:finalize!)
      claim_submission_job.perform(claim, SecureRandom.uuid)
    end
  end
end
