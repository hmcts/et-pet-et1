require "rails_helper"

RSpec.describe DiversityDataExport, type: :service do
  let(:diversity) {  build_stubbed(:diversity) }
  let(:uuid) { "246b26b3-e383-4b68-b5b7-6d4ed6c76093" }
  let(:diversity_data) {{
    body:
      { command: "BuildDiversityResponse",
       data:
        {claim_type: "Discrimination",
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
        uuid: uuid }
      }
  }

  describe 'send the diversity data' do
    before do
      allow(Diversity).to receive(:find).and_return diversity
      allow(SecureRandom).to receive(:uuid).and_return uuid
    end

    it 'as post via HTTParty' do
      dde = DiversityDataExport.new(diversity.id)
      expect(HTTParty).to receive(:post).with("/diversity/build_diversity_response", diversity_data)
      dde.send_data
    end

    context 'failed call' do
      it 'as post via HTTParty' do
        dde = DiversityDataExport.new(diversity.id)
        HTTParty.stub(:post).and_raise("Cannot connect")
        HTTParty.should_receive(:post).at_least(3)
        dde.send_data
      end
    end
  end
end