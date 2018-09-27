require 'rails_helper'

RSpec.describe EtApi, type: :service do
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
        claim = example_claim
        employment = example_claim.employment
        expect(json).to include case_type: claim.multiple_claimants? ? 'Multiple' : 'Single',
                                claim_details: claim.claim_details,
                                date_of_receipt: claim.submitted_at.strftime('%FT%T.%L%:z'),
                                desired_outcomes: claim.desired_outcomes.map(&:to_s),
                                discrimination_claims: claim.discrimination_claims.map(&:to_s),
                                employment_details: a_hash_including(
                                  :average_hours_worked_per_week => employment.average_hours_worked_per_week,
                                  :benefit_details => employment.benefit_details,
                                  :end_date => employment.end_date.try(:strftime, '%Y-%m-%d'),
                                  :enrolled_in_pension_scheme => employment.enrolled_in_pension_scheme,
                                  :found_new_job => employment.found_new_job,
                                  :gross_pay => employment.gross_pay,
                                  :gross_pay_period_type => employment.gross_pay_period_type,
                                  :job_title => employment.job_title,
                                  :net_pay => employment.net_pay,
                                  :net_pay_period_type => employment.net_pay_period_type,
                                  :new_job_gross_pay => employment.new_job_gross_pay,
                                  :new_job_start_date => employment.new_job_start_date.try(:strftime, '%Y-%m-%d'),
                                  :notice_pay_period_count => employment.notice_pay_period_count,
                                  :notice_pay_period_type => employment.notice_pay_period_type,
                                  :notice_period_end_date => employment.notice_period_end_date.try(:strftime, '%Y-%m-%d'),
                                  :start_date => employment.start_date.try(:strftime, '%Y-%m-%d'),
                                  :worked_notice_period_or_paid_in_lieu => employment.worked_notice_period_or_paid_in_lieu
                                ),
                                is_unfair_dismissal: claim.is_unfair_dismissal,
                                jurisdiction: claim.attracts_higher_fee? ? 2 : 1,
                                office_code: claim.office.code,
                                other_claim_details: claim.other_claim_details,
                                other_known_claimant_names: claim.other_known_claimant_names,
                                other_outcome: claim.other_outcome,
                                pay_claims: claim.pay_claims.map(&:to_s),
                                reference: claim.fee_group_reference,
                                send_claim_to_whistleblowing_entity: claim.send_claim_to_whistleblowing_entity,
                                submission_channel: "Web",
                                submission_reference: claim.reference


      end
    end
    shared_examples 'has valid primary claimant json' do
      let(:example_claimant) { example_claim.primary_claimant }
      let(:example_address) { example_claimant.address }
      it 'presents the correct claimant data' do
        # Act
        described_class.create_claim example_claim

        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys[:data].detect { |command| command[:command] == 'BuildPrimaryClaimant' }[:data]
        expect(json).to include title: example_claimant.title.try(:titleize),
                                first_name: example_claimant.first_name,
                                last_name: example_claimant.last_name,
                                gender: { 'male' => 'Male', 'female' => 'Female', 'prefer_not_to_say' => 'N/K' }[example_claimant.gender],
                                email_address: example_claimant.email_address,
                                date_of_birth: example_claimant.date_of_birth.strftime('%Y-%m-%d'),
                                contact_preference: example_claimant.contact_preference.try(:humanize),
                                fax_number: example_claimant.fax_number,
                                special_needs: example_claimant.special_needs,
                                mobile_number: example_claimant.mobile_number,
                                address_telephone_number: example_claimant.address_telephone_number,
                                address_attributes: example_address.nil? ? nil : a_hash_including(building: example_address.building, county: example_address.county, locality: example_address.locality, post_code: example_address.post_code, street: example_address.street)
      end
    end
    shared_examples 'has valid primary respondent json' do
      let(:example_respondent) { example_claim.primary_respondent }
      let(:example_address) { example_respondent.address }
      let(:example_work_address) { example_respondent.work_address }
      it 'presents the correct respondent data' do
        # Act
        described_class.create_claim example_claim

        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys[:data].detect { |command| command[:command] == 'BuildPrimaryRespondent' }[:data]
        expect(json).to include acas_certificate_number: example_respondent.acas_early_conciliation_certificate_number,
                                acas_exemption_code: example_respondent.no_acas_number_reason,
                                address_attributes: a_hash_including(building: example_address.building, county: example_address.county, locality: example_address.locality, post_code: example_address.post_code, street: example_address.street),
                                address_telephone_number: example_respondent.address_telephone_number,
                                alt_phone_number: example_respondent.work_address_telephone_number,
                                contact: nil,
                                contact_preference: nil,
                                disability: nil,
                                disability_information: nil,
                                dx_number: nil,
                                email_address: nil,
                                employment_at_site_number: nil,
                                fax_number: nil,
                                name: example_respondent.name,
                                organisation_employ_gb: nil,
                                organisation_more_than_one_site: nil,
                                work_address_attributes: example_work_address.nil? ? nil : a_hash_including(building: example_work_address.building, county: example_work_address.county, locality: example_work_address.locality, post_code: example_work_address.post_code, street: example_work_address.street),
                                work_address_telephone_number: example_respondent.work_address_telephone_number
      end
    end
    shared_examples 'has valid primary representative json' do
      let(:example_rep) { example_claim.representative }
      let(:example_address) { example_rep.address }
      let(:rep_types) do
        {
          'citizen_advice_bureau' => 'CAB',
          'free_representation_unit' => 'FRU',
          'law_centre' => 'Law Centre',
          'trade_union' => 'Union',
          'solicitor' => 'Solicitor',
          'private_individual' => 'Private Individual',
          'trade_association' => 'Trade Association',
          'other' => 'Other'
        }
      end
      it 'presents the correct respondent data' do
        # Act
        described_class.create_claim example_claim

        # Assert
        json = JSON.parse(recorded_request.body).deep_symbolize_keys[:data].detect { |command| command[:command] == 'BuildPrimaryRepresentative' }[:data]
        r = example_rep
        expect(json).to include address_attributes: a_hash_including(building: example_address.building, county: example_address.county, locality: example_address.locality, post_code: example_address.post_code, street: example_address.street),
                                address_telephone_number: r.address_telephone_number,
                                contact_preference: nil,
                                dx_number: r.dx_number,
                                email_address: r.email_address,
                                fax_number: nil,
                                mobile_number: r.mobile_number,
                                name: r.name,
                                organisation_name: r.organisation_name,
                                reference: nil,
                                representative_type: rep_types[r.type]
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
