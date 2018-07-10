require "rails_helper"

RSpec.describe DiversityDataExport, type: :service do
  ENV['ET_API_URL'] = 'http://127.0.0.1:3000/api/v2'

  let(:diversity) { build_stubbed(:diversity) }
  let(:uuid) { "246b26b3-e383-4b68-b5b7-6d4ed6c76093" }
  let(:uri) { URI.join('http://127.0.0.1:3000/api/v2', '/diversity/build_diversity_response') }
  let(:httpx) { class_double(HTTPX) }
  let(:diversity_data) {
    {
      command: "BuildDiversityResponse",
      data:
      { claim_type: "Discrimination",
        sex: "Prefer not to say",
        sexual_identity: "Bisexual",
        age_group: "35-44",
        ethnicity: "Asian / Asian British",
        ethnicity_subgroup: "Chinese",
        disability: "No",
        caring_responsibility: "No",
        gender: "Female (including male-to-female trans women)",
        gender_at_birth: "No",
        pregnancy: "No",
        relationship: "Married",
        religion: "Jewish" },
      uuid: uuid
    }
  }
  let(:headers) { { 'Accept' => 'application/json' } }

  describe 'send the diversity data' do
    before do
      allow(Diversity).to receive(:find).and_return diversity
      allow(HTTPX).to receive(:timeout).with(total_timeout: 10).and_return httpx
    end

    it 'as post via HTTPX' do
      dde = DiversityDataExport.new(diversity.id, uuid)
      expect(httpx).to receive(:post).with(uri, headers: headers, json: diversity_data)
      dde.send_data
    end

    it 'I can read response of the call' do
      dde = DiversityDataExport.new(diversity.id, uuid)
      allow(httpx).to receive(:post).and_return 'response'
      dde.send_data
      expect(dde.response).to eql('response')
    end
  end
end
