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
        errors = []

        match do |actual|
          errors = []
          json = JSON.parse(actual.body).deep_symbolize_keys[:data].detect { |command| command[:command] == expected_command }
          expect(json).to be_a_valid_api_command(expected_command).version(@version).for_db_data(@db_data)
        rescue RSpec::Expectations::ExpectationNotMetError => err
          errors << "Json did not contain valid api command for #{expected_command}"
          errors.concat(err.message.lines.map { |l| "#{'  ' * 2}#{l.gsub(/\n\z/, '')}" })
          false
        end

        failure_message do |actual|
          "Expected sent request body to be a valid api command for #{expected_command} but it wasn't\n\nThe errors reported were: #{errors.join("\n")}"

        end
      end
      matcher :contain_api_command do |expected_command|
        match do |actual|
          JSON.parse(actual.body).deep_symbolize_keys[:data].any? { |command| command[:command] == expected_command }
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
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, single respondent and no representative' do
      include_context 'with api environment variable'
      include_context 'with build claim endpoint recording'
      include_context 'with command matcher'
      include_context 'issue command before each'
      let(:example_claim) { create(:claim, :with_pdf, :without_representative, :no_attachments) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.not_to contain_api_command('BuildPrimaryRepresentative') }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with multiple claimants, single respondent and a representative' do
      include_context 'with build claim endpoint recording'
      include_context 'with api environment variable'
      include_context 'with command matcher'
      include_context 'issue command before each'
      let(:example_claim) { create(:claim, :with_pdf, :with_secondary_claimants, :no_attachments) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.to contain_valid_api_command('BuildSecondaryClaimants').version('2').for_db_data(example_claim.secondary_claimants) }
      it { is_expected.not_to contain_api_command('BuildSecondaryRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, multiple respondents and a representative' do
      include_context 'with api environment variable'
      include_context 'with build claim endpoint recording'
      include_context 'with command matcher'
      include_context 'issue command before each'
      let(:example_claim) { create(:claim, :with_pdf, :with_secondary_respondents, :no_attachments) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildSecondaryRespondents').version('2').for_db_data(example_claim.secondary_respondents) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with multiple claimants via CSV, single respondent and a representative' do
      include_context 'with api environment variable'
      include_context 'with build claim endpoint recording'
      include_context 'with command matcher'
      include_context 'issue command before each'
      let(:example_claim) { create(:claim, :without_rtf, :with_pdf) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.to contain_valid_api_command('BuildClaimantsFile').version('2').for_db_data(example_claim.additional_claimants_csv) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildClaimantsRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimDetailsFile') }
    end

    context 'with a claim with single claimant, single respondent, a representative and an rtf file' do
      include_context 'with api environment variable'
      include_context 'with build claim endpoint recording'
      include_context 'with command matcher'
      include_context 'issue command before each'
      let(:example_claim) { create(:claim, :with_pdf, :without_additional_claimants_csv) }

      it { is_expected.to contain_valid_api_command('BuildClaim').version('2').for_db_data(example_claim) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryClaimant').version('2').for_db_data(example_claim.primary_claimant) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRespondent').version('2').for_db_data(example_claim.primary_respondent) }
      it { is_expected.to contain_valid_api_command('BuildPrimaryRepresentative').version('2').for_db_data(example_claim.representative) }
      it { is_expected.to contain_valid_api_command('BuildPdfFile').version('2').for_db_data(example_claim.pdf) }
      it { is_expected.to contain_valid_api_command('BuildClaimDetailsFile').version('2').for_db_data(example_claim.claim_details_rtf) }
      it { is_expected.not_to contain_api_command('BuildSecondaryClaimants') }
      it { is_expected.not_to contain_api_command('BuildClaimantsRespondents') }
      it { is_expected.not_to contain_api_command('BuildSecondaryRepresentatives') }
      it { is_expected.not_to contain_api_command('BuildClaimantsFile') }
    end
  end
end
