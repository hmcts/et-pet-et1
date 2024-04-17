# rubocop:disable RSpec/MultipleExpectations
require 'rails_helper'

RSpec.describe SubmitClaimToApiService, type: :service do
  shared_context 'with api environment variable' do
    let(:et_api_url) { 'http://api.et.net:4000/api/v2' }
    around do |example|
      ClimateControl.modify ET_API_URL: et_api_url do
        example.run
      end
    end
  end

  shared_context 'with command matcher' do
    matcher :contain_valid_api_command do |expected_command|
      chain :version do |version|
        @version = version
      end
      chain :for_db_data do |db_data|
        @db_data = db_data
      end
      errors = []

      match do |actual|
        errors = []
        json = JSON.parse(actual.body).deep_symbolize_keys[:data].detect { |command| command[:command] == expected_command }
        expect(json).to be_a_valid_api_command(expected_command).version(@version).for_db_data(@db_data)
      rescue RSpec::Expectations::ExpectationNotMetError => e
        errors << "Json did not contain valid api command for #{expected_command}"
        errors.concat(e.message.lines.map { |l| "#{'  ' * 2}#{l.gsub(/\n\z/, '')}" })
        false
      end

      failure_message do
        "Expected sent request body to be a valid api command for #{expected_command} but it wasn't\n\nThe errors reported were: #{errors.join("\n")}"

      end
    end
    matcher :contain_api_command do |expected_command|
      match do |actual|
        JSON.parse(actual.body).deep_symbolize_keys[:data].any? { |command| command[:command] == expected_command }
      end
    end
  end

  describe '.call' do

    let(:build_claim_url) { "#{et_api_url}/claims/build_claim" }

    shared_context 'with build claim endpoint recording' do
      my_request = nil
      let(:recorded_request) { my_request }

      before do
        my_request = nil
        stub_request(:post, build_claim_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return do |request|
          my_request = request
          { body: '{}', headers: { 'Content-Type': 'application/json' } }
        end
      end
    end

    shared_context 'with action performed before each example' do
      before do
        described_class.call example_claim
      end
    end

    include_context 'with api environment variable'
    include_context 'with build claim endpoint recording'
    include_context 'with command matcher'

    context 'with a claim with single claimant, single respondent and a representative' do
      let(:example_claim) { create(:claim, :no_attachments, :not_submitted) }

      context 'validating recorded request' do
        subject { recorded_request }

        include_context 'with action performed before each example'

        it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
        it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
        it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
        it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
        it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
        it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
        it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
        it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
        it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
      end

      context 'validating returned service object' do
        subject(:service) { described_class.call example_claim }

        it 'is valid' do
          expect(service).to be_valid
        end

        it 'has no errors' do
          service.valid?
          expect(service.errors).to be_empty
        end
      end

      context 'validating the state of the given claim' do
        include_context 'with action performed before each example'
        it 'has its submitted_at attribute set' do
          expect(example_claim.reload).to have_attributes(submitted_at: instance_of(ActiveSupport::TimeWithZone))
        end

        it 'has its state set to submitted' do
          expect(example_claim.reload).to have_attributes(state: 'submitted')
        end
      end
    end

    context 'with a claim with single claimant, single respondent (with no work address) and a representative' do
      subject { recorded_request }

      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :no_attachments, :primary_respondent_with_no_work_address, :not_submitted) }

      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, single respondent (with no addresses) and a representative' do
      subject { recorded_request }

      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :no_attachments, :primary_respondent_with_no_addresses, :not_submitted) }

      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, single respondent and a representative (with no address)' do
      subject { recorded_request }

      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :no_attachments, :primary_representative_with_no_address, :not_submitted) }

      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, single respondent and no representative' do
      subject { recorded_request }

      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :without_representative, :no_attachments, :not_submitted) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.not_to contain_api_command('BuildPrimaryRepresentative') }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, single respondent, no representative and no employment' do
      subject { recorded_request }

      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :without_representative, :no_attachments, :without_employment, :not_submitted) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.not_to contain_api_command('BuildPrimaryRepresentative') }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with multiple claimants, single respondent and a representative' do
      subject { recorded_request }

      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :with_secondary_claimants, :no_attachments, :not_submitted) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildSecondaryClaimants').version('2').for_db_data(example_claim.secondary_claimants) }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, multiple respondents and a representative' do
      subject { recorded_request }

      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :with_secondary_respondents, :no_attachments, :not_submitted) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildSecondaryRespondents').version('2').for_db_data(example_claim.secondary_respondents) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with multiple claimants via CSV, single respondent and a representative' do
      subject { recorded_request }

      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :without_rtf, :not_submitted) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildClaimantsFile').version('2').for_db_data(example_claim.additional_claimants_csv) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildClaimantsRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, single respondent, a representative and an rtf file' do
      subject { recorded_request }

      include_context 'with action performed before each example'
      let(:example_claim) { create(:claim, :without_additional_claimants_csv, :not_submitted) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildClaimDetailsFile').version('2').for_db_data(example_claim.claim_details_rtf) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildClaimantsRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
    end

    context 'with a timeout from the API endpoint' do
      let(:example_claim) { create(:claim, :no_attachments, :without_representative, :not_submitted) }

      before { stub_request(:post, build_claim_url).to_timeout }

      it 'raises a retryable exception' do
        expect { described_class.call example_claim }.to raise_error(ApiService::Timeout) { |error| expect(error.retry?).to be true }
      end
    end

    context 'with a 422 from the API endpoint' do
      subject(:service) { described_class.call example_claim, uuid: 'my-claim-uuid' }

      let(:example_claim) { create(:claim, :no_attachments, :without_representative, :not_submitted) }

      before do
        stub_request(:post, build_claim_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return do |request|
          request_data = JSON.parse(request.body)
          body_data = {
            status: 'not_accepted',
            uuid: 'my-claim-uuid',
            errors: [
              {
                status: 422,
                code: "invalid_address",
                title: "Invalid address",
                detail: "Invalid address",
                source: "/data/2/address_attributes",
                command: "BuildPrimaryClaimant",
                uuid: request_data.dig('data', 1, 'uuid')
              }
            ]
          }
          { body: body_data.to_json, status: 422, headers: { 'Content-Type': 'application/json' } }
        end

      end

      it 'is not valid' do
        expect(service).not_to be_valid
      end

      it 'has errors' do
        service.valid?
        expect(service.errors).to be_present
      end
    end

    context 'with a 400 from the API endpoint' do
      let(:example_claim) { create(:claim, :no_attachments, :without_representative, :not_submitted) }

      before { stub_request(:post, build_claim_url).to_return(body: '{}', status: 400, headers: { 'Content-Type': 'application/json' }) }

      it 'raises a non retryable exception' do
        expect { described_class.call example_claim }.to raise_error(ApiService::BadRequest) { |error| expect(error.retry?).to be false }
      end
    end

    context 'with a 500 from the API endpoint' do
      let(:example_claim) { create(:claim, :no_attachments, :without_representative, :not_submitted) }

      before { stub_request(:post, build_claim_url).to_return(body: '{}', status: 500, headers: { 'Content-Type': 'application/json' }) }

      it 'raises a retryable exception' do
        expect { described_class.call example_claim }.to raise_error(ApiService::InternalServerError) { |error| expect(error.retry?).to be true }
      end
    end
  end
end
# rubocop:enable RSpec/MultipleExpectations
