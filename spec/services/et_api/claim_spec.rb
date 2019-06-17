require 'rails_helper'

RSpec.describe EtApi::Claim, type: :service do
  let(:pdf_url) { 'http://localhost:9000/etapibuckettest/5KL3ugfH8V8DEn7VaTsxZ2Eh?response-content-disposition=attachment%3B%20filename%3D%22et1_first_last.pdf%22%3B%20filename%2A%3DUTF-8%27%27et1_first_last.pdf\u0026X-Amz-Algorithm=AWS4-HMAC-SHA256\u0026X-Amz-Credential=accessKey1%2F20190429%2Fus-east-1%2Fs3%2Faws4_request\u0026X-Amz-Date=20190429T073842Z\u0026X-Amz-Expires=3600\u0026X-Amz-SignedHeaders=host\u0026X-Amz-Signature=4b81e1773553ef2908afa8e61a57a1a6af83a0f9af9a69eea606a6606ca1f15e' }
  let(:et_api_url) { 'http://api.et.net:4000/api/v2' }
  let(:build_claim_url) { "#{et_api_url}/claims/build_claim" }
  let(:api_create_claim_response) do
    {
      status: 'accepted',
      meta: {
        BuildClaim: {
          reference: '222000000200',
          office: {
            name: 'London Central',
            code: 22,
            telephone: '020 7273 8603',
            address: 'Victory House, 30-34 Kingsway, London WC2B 6EX',
            email: 'londoncentralet@hmcts.gsi.gov.uk'
          },
          pdf_url: pdf_url
        },
        BuildPrimaryRespondent: {},
        BuildPrimaryClaimant: {},
        BuildSecondaryClaimants: {},
        BuildSecondaryRespondents: {},
        BuildPrimaryRepresentative: {}
      },
      uuid: '106144b2-537b-4066-b4bc-2982531d9b9a'
    }
  end
  let(:api_stub) do
    stub_request(:post, build_claim_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return(body: api_create_claim_response.to_json, status: 202, headers: { 'Content-Type': 'application/json' })
  end
  let(:example_claim) { build(:claim, :not_submitted, fee_group_reference: nil, stored_pdf_url: nil) }
  subject(:service) { described_class.new(base_url: et_api_url) }

  before do
    api_stub
  end

  it 'submits claim without any error conditions and finalizes claim' do
    # Act - Call the service with example claim
    service.call(example_claim)

    # Assert - Make sure the api has been called and that the claim
    body_matcher = hash_including uuid: instance_of(String),
      command: 'SerialSequence',
      data: a_collection_including(
        a_hash_including('command' => 'BuildClaim', 'data' => hash_including('date_of_receipt' => instance_of(String))),
        a_hash_including('command' => 'BuildPrimaryClaimant'),
        a_hash_including('command' => 'BuildPrimaryRespondent'),
        a_hash_including('command' => 'BuildPrimaryRepresentative'),
        a_hash_including('command' => 'BuildClaimantsFile'),
        a_hash_including('command' => 'BuildClaimDetailsFile')
      )
    expect(WebMock).to have_requested(:post, "#{et_api_url}/claims/build_claim").with headers: {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    },
      body: body_matcher
  end

  it 'stores the reference and and pdf_url in the claim' do
    # Act - Call the service with example claim
    service.call(example_claim)

    # Assert - Check the claim
    expect(example_claim).to have_attributes fee_group_reference: api_create_claim_response.dig(:meta, :BuildClaim, :reference),
                                     stored_pdf_url: pdf_url
  end

  it 'stores the office details in the claim' do
    # Act - Call the service with example claim
    service.call(example_claim)

    # Assert - Check the claim
    expect(example_claim.office).to have_attributes api_create_claim_response.dig(:meta, :BuildClaim, :office)
  end

  it 'sets the state to submitted' do
    # Act - Call the service with example claim
    service.call(example_claim)

    # Assert - Check the claim
    expect(example_claim).to have_attributes state: 'submitted'
  end

  it 'sets the submitted_at attribute' do
    # Act - Call the service with example claim
    service.call(example_claim)

    # Assert - Check the claim
    expect(example_claim).to have_attributes submitted_at: instance_of(DateTime)
  end

  it 'returns after timeout period but background thread keeps trying for 3 attempts with a backup sidekiq job scheduled' do
    raise "TODO"
  end

  it 'cancels the backup sidekiq job if no error condition' do
    raise "TODO"
  end

  it 'cancels the backup sidekiq job if the retrying fixes the issue' do
    raise "TODO"
  end

  it 'does not cancel the backup sidekiq job if the retrying does not fix the issue' do
    raise "TODO"
  end

  it 'finalizes claim if retrying fixes the issue' do
    raise "TODO"
  end

  it 'does not finalize the claim if retrying does not fix the issue' do
    raise "TODO"
  end
end
