require 'rails_helper'

RSpec.describe EtApi, type: :service do
  let(:errors) { [] }
  shared_context 'with api environment variable' do
    let(:et_api_url) { 'http://api.et.net:4000/api/v2' }
    around do |example|
      ClimateControl.modify ET_API_URL: et_api_url do
        example.run
      end
    end
  end

  describe '.create_claim' do
    shared_context 'with build claim endpoint recording' do
      my_request = nil
      let(:build_claim_url) { "#{et_api_url}/claims/build_claim" }

      before do
        my_request = nil
        stub_request(:post, build_claim_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return do |request|
          my_request = request
          { body: '{}', headers: { 'Content-Type': 'application/json' } }
        end
      end

      subject(:recorded_request) { my_request }

    end
    shared_context 'with command matcher' do
      matcher :contain_valid_api_command do |expected_command|
        chain :version do |version|
          @version = version
        end
        chain :for_db_data do |db_data|
          @db_data = db_data
        end

        match do |actual|
          json = JSON.parse(actual.body).deep_symbolize_keys[:data].detect { |command| command[:command] == expected_command }
          expect(json).to be_a_valid_api_command(expected_command).version(@version).for_db_data(@db_data)
        end
      end
    end
    shared_context 'issue command before each' do
      before do
        described_class.create_claim example_claim
      end
    end
    context 'with a claim with single claimant, single respondent and a representative' do
      include_context 'with api environment variable'
      include_context 'with build claim endpoint recording'
      include_context 'with command matcher'
      include_context 'issue command before each'
      let(:example_claim) { create(:claim, :with_pdf, :no_attachments) }

      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it 'includes the json for claim, claimant, single respondent and a representative' do
        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys
        aggregate_failures 'validate json content at top level' do
          expect(json).to include uuid: instance_of(String), command: 'SerialSequence'
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildClaim')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryClaimant')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryRespondent')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryRepresentative')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPdfFile')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryClaimants')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryRespondents')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryRepresentatives')
          expect(json[:data]).not_to include hash_including(command: 'BuildClaimantsFile')
          expect(json[:data]).not_to include hash_including(command: 'BuildClaimDetailsFile')
        end
      end
    end

    context 'with a claim with single claimant, single respondent and no representative' do
      include_context 'with api environment variable'
      include_context 'with build claim endpoint recording'
      include_context 'with command matcher'
      include_context 'issue command before each'
      let(:example_claim) { create(:claim, :with_pdf, :without_representative, :no_attachments) }

      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it 'includes the json for claim, claimant, single respondent and a representative' do
        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys
        aggregate_failures 'validate json content at top level' do
          expect(json).to include uuid: instance_of(String), command: 'SerialSequence'
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildClaim')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryClaimant')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryRespondent')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPdfFile')
          expect(json[:data]).not_to include hash_including(command: 'BuildPrimaryRepresentative')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryClaimants')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryRespondents')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryRepresentatives')
          expect(json[:data]).not_to include hash_including(command: 'BuildClaimantsFile')
          expect(json[:data]).not_to include hash_including(command: 'BuildClaimDetailsFile')
        end
      end
    end

    context 'with a claim with multiple claimants, single respondent and a representative' do
      include_context 'with build claim endpoint recording'
      include_context 'with api environment variable'
      include_context 'with command matcher'
      include_context 'issue command before each'
      let(:example_claim) { create(:claim, :with_pdf, :with_secondary_claimants, :no_attachments) }

      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildSecondaryClaimants').version('2').for_db_data(example_claim.secondary_claimants) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it 'includes the json for claim, claimant, single respondent and a representative' do
        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys
        aggregate_failures 'validate json content at top level' do
          expect(json).to include uuid: instance_of(String), command: 'SerialSequence'
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildClaim')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryClaimant')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryRespondent')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryRepresentative')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPdfFile')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildSecondaryClaimants')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryRespondents')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryRepresentatives')
          expect(json[:data]).not_to include hash_including(command: 'BuildClaimantsFile')
          expect(json[:data]).not_to include hash_including(command: 'BuildClaimDetailsFile')
        end
      end
    end

    context 'with a claim with single claimant, multiple respondents and a representative' do
      include_context 'with api environment variable'
      include_context 'with build claim endpoint recording'
      include_context 'with command matcher'
      include_context 'issue command before each'
      let(:example_claim) { create(:claim, :with_pdf, :with_secondary_respondents, :no_attachments) }

      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildSecondaryRespondents').version('2').for_db_data(example_claim.secondary_respondents) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it 'includes the json for claim, claimant, single respondent and a representative' do
        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys
        aggregate_failures 'validate json content at top level' do
          expect(json).to include uuid: instance_of(String), command: 'SerialSequence'
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildClaim')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryClaimant')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryRespondent')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryRepresentative')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPdfFile')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildSecondaryRespondents')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryClaimants')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryRepresentatives')
          expect(json[:data]).not_to include hash_including(command: 'BuildClaimantsFile')
          expect(json[:data]).not_to include hash_including(command: 'BuildClaimDetailsFile')
        end
      end
    end

    context 'with a claim with multiple claimants via CSV, single respondent and a representative' do
      include_context 'with api environment variable'
      include_context 'with build claim endpoint recording'
      include_context 'with command matcher'
      include_context 'issue command before each'
      let(:example_claim) { create(:claim, :without_rtf, :with_pdf) }

      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it 'includes the json for claim, claimant, single respondent and a representative' do
        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys
        aggregate_failures 'validate json content at top level' do
          expect(json).to include uuid: instance_of(String), command: 'SerialSequence'
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildClaim')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryClaimant')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryRespondent')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryRepresentative')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPdfFile')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildClaimantsFile')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryClaimants')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryRespondents')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryRepresentatives')
          expect(json[:data]).not_to include hash_including(command: 'BuildClaimDetailsFile')
        end
      end
    end

    context 'with a claim with single claimant, single respondent, a representative and an rtf file' do
      include_context 'with api environment variable'
      include_context 'with build claim endpoint recording'
      include_context 'with command matcher'
      include_context 'issue command before each'
      let(:example_claim) { create(:claim, :with_pdf, :without_additional_claimants_csv) }

      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it 'includes the json for claim, claimant, single respondent and a representative' do
        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys
        aggregate_failures 'validate json content at top level' do
          expect(json).to include uuid: instance_of(String), command: 'SerialSequence'
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildClaim')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryClaimant')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryRespondent')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPrimaryRepresentative')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildPdfFile')
          expect(json[:data]).to include hash_including(uuid: instance_of(String), command: 'BuildClaimDetailsFile')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryClaimants')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryRespondents')
          expect(json[:data]).not_to include hash_including(command: 'BuildSecondaryRepresentatives')
          expect(json[:data]).not_to include hash_including(command: 'BuildClaimantsFile')
        end
      end
    end
  end
end
