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
      before do
        my_request = nil
        stub_request(:post, build_claim_url).with(headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }).to_return do |request|
          my_request = request
          { body: '{}', headers: { 'Content-Type': 'application/json' } }
        end
      end

      let(:recorded_request) { my_request }

    end
    shared_examples 'has valid claim json' do
      it 'presents the correct claim data' do
        # Act
        described_class.create_claim example_claim

        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys[:data].detect { |command| command[:command] == 'BuildClaim' }[:data]
        expect(json).to be_a_valid_api_command('BuildClaim').version('2').for_db_data(example_claim)
      end
    end
    shared_examples 'has valid primary claimant json' do
      let(:example_claimant) { example_claim.primary_claimant }
      it 'presents the correct claimant data' do
        # Act
        described_class.create_claim example_claim

        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys[:data].detect { |command| command[:command] == 'BuildPrimaryClaimant' }
        expect(json).to be_a_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claimant)
      end
    end
    shared_examples 'has valid secondary claimants json' do
      let(:example_claimants) { example_claim.secondary_claimants }
      it 'presents the correct claimants data' do
        # Act
        described_class.create_claim example_claim

        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys[:data].detect { |command| command[:command] == 'BuildSecondaryClaimants' }
        expect(json).to be_a_valid_api_command('BuildSecondaryClaimants').version('2').for_db_data(example_claimants)
      end
    end
    shared_examples 'has valid primary respondent json' do
      let(:example_respondent) { example_claim.primary_respondent }
      it 'presents the correct respondent data' do
        # Act
        described_class.create_claim example_claim

        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys[:data].detect { |command| command[:command] == 'BuildPrimaryRespondent' }
        expect(json).to be_a_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_respondent)
      end
    end
    shared_examples 'has valid secondary respondents json' do
      let(:example_respondents) { example_claim.secondary_respondents }
      it 'presents the correct respondents data' do
        # Act
        described_class.create_claim example_claim

        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys[:data].detect { |command| command[:command] == 'BuildSecondaryRespondents' }
        expect(json).to be_a_valid_api_command('BuildSecondaryRespondents').version('2').for_db_data(example_respondents)
      end
    end
    shared_examples 'has valid primary representative json' do
      let(:example_rep) { example_claim.representative }
      it 'presents the correct representative data' do
        # Act
        described_class.create_claim example_claim

        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys[:data].detect { |command| command[:command] == 'BuildPrimaryRepresentative' }
        expect(json).to be_a_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_rep)
      end
    end
    context 'with a claim with single claimant, single respondent and a representative' do
      include_context 'with api environment variable'
      include_context 'with build claim endpoint recording'
      include_examples 'has valid primary claimant json'
      include_examples 'has valid primary respondent json'
      include_examples 'has valid primary representative json'
      include_examples 'has valid claim json'
      let(:example_claim) { create(:claim, :with_pdf, :no_attachments) }
      let(:build_claim_url) { "#{et_api_url}/claims/build_claim" }
      it 'includes the json for claim, claimant, single respondent and a representative' do
        # Act
        described_class.create_claim example_claim

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
      include_context 'with build claim endpoint recording'
      include_context 'with api environment variable'
      include_examples 'has valid primary claimant json'
      include_examples 'has valid primary respondent json'
      include_examples 'has valid claim json'
      let(:example_claim) { create(:claim, :with_pdf, :without_representative, :no_attachments) }
      let(:build_claim_url) { "#{et_api_url}/claims/build_claim" }
      it 'includes the json for claim, claimant, single respondent and a representative' do
        # Act
        described_class.create_claim example_claim

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
      include_examples 'has valid primary claimant json'
      include_examples 'has valid secondary claimants json'
      include_examples 'has valid primary respondent json'
      include_examples 'has valid primary representative json'
      include_examples 'has valid claim json'

      let(:example_claim) { create(:claim, :with_pdf, :with_secondary_claimants, :no_attachments) }
      let(:build_claim_url) { "#{et_api_url}/claims/build_claim" }
      it 'includes the json for claim, claimant, single respondent and a representative' do
        # Act
        described_class.create_claim example_claim

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
      include_context 'with build claim endpoint recording'
      include_context 'with api environment variable'
      include_examples 'has valid primary claimant json'
      include_examples 'has valid primary respondent json'
      include_examples 'has valid secondary respondents json'
      include_examples 'has valid primary representative json'
      include_examples 'has valid claim json'
      let(:example_claim) { create(:claim, :with_pdf, :with_secondary_respondents, :no_attachments) }
      let(:build_claim_url) { "#{et_api_url}/claims/build_claim" }
      it 'includes the json for claim, claimant, single respondent and a representative' do
        # Act
        described_class.create_claim example_claim

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
      include_context 'with build claim endpoint recording'
      include_context 'with api environment variable'
      include_examples 'has valid primary claimant json'
      include_examples 'has valid primary respondent json'
      include_examples 'has valid primary representative json'
      include_examples 'has valid claim json'
      let(:example_claim) { create(:claim, :without_rtf, :with_pdf) }
      let(:build_claim_url) { "#{et_api_url}/claims/build_claim" }
      it 'includes the json for claim, claimant, single respondent and a representative' do
        # Act
        described_class.create_claim example_claim

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
      include_context 'with build claim endpoint recording'
      include_context 'with api environment variable'
      include_examples 'has valid primary claimant json'
      include_examples 'has valid primary respondent json'
      include_examples 'has valid primary representative json'
      include_examples 'has valid claim json'
      let(:example_claim) { create(:claim, :with_pdf, :without_additional_claimants_csv) }
      let(:build_claim_url) { "#{et_api_url}/claims/build_claim" }
      it 'includes the json for claim, claimant, single respondent and a representative' do
        # Act
        described_class.create_claim example_claim

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
