require 'rails_helper'

RSpec.describe EtApi, type: :service do
  describe '.create_claim' do
    subject(:service) { described_class.create_claim example_claim, submit_claim_service: mock_submit_claim_service }

    let(:mock_submit_claim_service) { class_spy('SubmitClaimToApiService', call: mock_submit_claim_service_instance) }
    let(:mock_submit_claim_service_instance) { instance_spy('SubmitClaimToApiService', valid?: true, errors: []) }
    let(:example_claim) { create(:claim, :no_attachments) }

    it 'delegates to SubmitClaimToApiService' do
      expect(service).to be mock_submit_claim_service_instance
    end
  end

  describe '.build_diversity_response' do
    subject(:service) { described_class.build_diversity_response example_diversity_response, submit_diversity_response_service: mock_submit_diversity_service }

    let(:mock_submit_diversity_service) { class_spy('SubmitDiversityResponseToApiService', call: mock_submit_diversity_service_instance) }
    let(:mock_submit_diversity_service_instance) { instance_spy('SubmitDiversityResponseToApiService', valid?: true, errors: []) }
    let(:example_diversity_response) { create :diversity }

    it 'delegates to SubmitClaimToApiService' do
      expect(service).to be mock_submit_diversity_service_instance
    end
  end
end
