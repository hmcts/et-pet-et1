require 'rails_helper'
RSpec.feature 'Output Form' do
  include ActiveJob::TestHelper

  # @mock_et_api
  scenario 'Full claim with many claimants and respondents', js: true, mock_et_api: true do
    # Given I am on the new claim page
    new_claim_page.load
    # When I start a new claim
    new_claim_page.start_a_claim.click
    # And I save my claim with a valid email address and password
    step_one_page.email.set('test@digital.justice.gov.uk')
    step_one_page.memorable_word.set('password')
    step_one_page.save_and_continue.click

    # And I fill in my claimant details with:
    table_hashes = [
        {'field' => 'title', 'value' => 'Mr'},
        {'field' => 'first_name', 'value' => 'First'},
        {'field' => 'last_name', 'value' => 'Last'},
        {'field' => 'date_of_birth', 'value' => '21/11/1982'},
        {'field' => 'gender', 'value' => 'Male'},
        {'field' => 'has_special_needs', 'value' => 'Yes'},
        {'field' => 'special_needs', 'value' => 'My special needs are as follows'}
    ]
    table_hashes.each do |hash|
      step_two_page.about_the_claimant do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then
          node.select(hash['value'])
        else
          node.set(hash['value'])
        end
      end
    end

    # And I fill in my claimant contact details with:
    table_hashes = [
        {'field' => 'building', 'value' => '102'},
        {'field' => 'street', 'value' => 'Petty France'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H 9AJ'},
        {'field' => 'country', 'value' => 'United Kingdom'},
        {'field' => 'telephone_number', 'value' => '01234 567890'},
        {'field' => 'alternative_telephone_number', 'value' => '01234 098765'},
        {'field' => 'correspondence', 'value' => 'Email'},
        {'field' => 'email_address', 'value' => 'test@digital.justice.gov.uk'}
    ]
    table_hashes.each do |hash|
      step_two_page.claimants_contact_details do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then
          node.select(hash['value'])
        else
          node.set(hash['value'])
        end
      end
    end

    # And I save the claimant details
    step_two_page.save_and_continue.click
    # And I answer Yes to the group claims question
    step_three_page.group_claims.set("Yes")

    # And I fill in the first group claimant details with:

    table_hashes = [
        {'field' => 'title', 'value' => 'Mrs'},
        {'field' => 'first_name', 'value' => 'GroupFirst'},
        {'field' => 'last_name', 'value' => 'GroupLast'},
        {'field' => 'date_of_birth', 'value' => '25/12/1989'},
        {'field' => 'building', 'value' => '104'},
        {'field' => 'street', 'value' => 'Oxford Street'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H 9JA'}
    ]
    table_hashes.each do |hash|
      step_three_page.group_claims.about_claimant_two do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then
          node.select(hash['value'])
        else
          node.set(hash['value'])
        end
      end
    end

    # And I choose to add more claimants
    step_three_page.group_claims.add_more_claimants.click

    # And I fill in the second group claimant details with:
    table_hashes = [
        {'field' => 'title', 'value' => 'Mrs'},
        {'field' => 'first_name', 'value' => 'Group2First'},
        {'field' => 'last_name', 'value' => 'Group2Last'},
        {'field' => 'date_of_birth', 'value' => '25/12/1988'},
        {'field' => 'building', 'value' => '106'},
        {'field' => 'street', 'value' => 'Regent Street'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H 9JB'}
    ]
    table_hashes.each do |hash|
      step_three_page.group_claims.about_claimant_three do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then
          node.select(hash['value'])
        else
          node.set(hash['value'])
        end
      end
    end

    # And I choose to add more claimants
    step_three_page.group_claims.add_more_claimants.click

    # And I fill in the third group claimant details with:
    table_hashes = [
        {'field' => 'title', 'value' => 'Mrs'},
        {'field' => 'first_name', 'value' => 'Group3First'},
        {'field' => 'last_name', 'value' => 'Group3Last'},
        {'field' => 'date_of_birth', 'value' => '21/12/1993'},
        {'field' => 'building', 'value' => '108'},
        {'field' => 'street', 'value' => 'Pall Mall'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H 9JJ'}
    ]
    table_hashes.each do |hash|
      step_three_page.group_claims.about_claimant_four do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then
          node.select(hash['value'])
        else
          node.set(hash['value'])
        end
      end
    end

    #     And I choose to add more claimants
    step_three_page.group_claims.add_more_claimants.click

    # And I fill in the fourth group claimant details with:
    table_hashes = [
        {'field' => 'title', 'value' => 'Mrs'},
        {'field' => 'first_name', 'value' => 'Group4First'},
        {'field' => 'last_name', 'value' => 'Group4Last'},
        {'field' => 'date_of_birth', 'value' => '21/11/1992'},
        {'field' => 'building', 'value' => '110'},
        {'field' => 'street', 'value' => 'Buckingham Pl'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H 9JT'}
    ]
    table_hashes.each do |hash|
      step_three_page.group_claims.about_claimant_five do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then
          node.select(hash['value'])
        else
          node.set(hash['value'])
        end
      end
    end

    #     And I choose to add more claimants
    step_three_page.group_claims.add_more_claimants.click

    # And I fill in the fifth group claimant details with:
    table_hashes = [
        {'field' => 'title', 'value' => 'Mrs'},
        {'field' => 'first_name', 'value' => 'Group5First'},
        {'field' => 'last_name', 'value' => 'Group5Last'},
        {'field' => 'date_of_birth', 'value' => '21/10/1991'},
        {'field' => 'building', 'value' => '112'},
        {'field' => 'street', 'value' => 'Oxford Road'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H 9JY'}
    ]
    table_hashes.each do |hash|
      step_three_page.group_claims.about_claimant_six do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then
          node.select(hash['value'])
        else
          node.set(hash['value'])
        end
      end
    end

    # And I save the group claims
    step_three_page.save_and_continue.click

    # And I answer Yes to the representative question
    step_four_page.representatives_details do |r|
      r.representative.set("Yes")
    end

    # And I fill in the representative's details with:
    table_hashes = [
        {'field' => 'type', 'value' => 'Solicitor'},
        {'field' => 'organisation_name', 'value' => 'Solicitors Are Us Fake Company'},
        {'field' => 'name', 'value' => 'Solicitor Name'}
    ]
    table_hashes.each do |hash|
      step_four_page.representatives_details.about_your_representative do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then
          node.select(hash['value'])
        else
          node.set(hash['value'])
        end
      end
    end

    # And I fill in the representative's contact details with:
    table_hashes = [
        {'field' => 'building', 'value' => '106'},
        {'field' => 'street', 'value' => 'Mayfair'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H 9PP'},
        {'field' => 'telephone_number', 'value' => '01111 123456'},
        {'field' => 'alternative_telephone_number', 'value' => '02222 654321'},
        {'field' => 'email_address', 'value' => 'solicitor.test@digital.justice.gov.uk'},
        {'field' => 'dx_number', 'value' => 'dx1234567890'}
    ]
    table_hashes.each do |hash|
      step_four_page.representatives_details.contact_details do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then
          node.select(hash['value'])
        else
          node.set(hash['value'])
        end
      end
    end

    # And I save the representative's details
    step_four_page.save_and_continue.click

    # And I fill in the respondent's details with:
    table_hashes = [
        {'field' => 'name', 'value' => 'Respondent Name'},
        {'field' => 'building', 'value' => '108'},
        {'field' => 'street', 'value' => 'Regent Street'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H 9QR'},
        {'field' => 'telephone_number', 'value' => '02222 321654'}
    ]
    table_hashes.each do |hash|
      step_five_page.about_the_respondent do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then
          node.select(hash['value'])
        else
          node.set(hash['value'])
        end
      end
    end

    # And I answer No to working at the same address question
    step_five_page.your_work_address.same_address.set("No")

    # And I fill in my work address with:
    table_hashes = [
        {'field' => 'building', 'value' => '110'},
        {'field' => 'street', 'value' => 'Piccadily Circus'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H 9ST'},
        {'field' => 'telephone_number', 'value' => '03333 423554'}
    ]

    table_hashes.each do |hash|
      step_five_page.your_work_address do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then
          node.select(hash['value'])
        else
          node.set(hash['value'])
        end
      end
    end

    # And I fill in my acas certificate number with AC123456/78/90
    step_five_page.acas.certificate_number.set('AC123456/78/90')

    # And I save the respondent's details
    step_five_page.save_and_continue.click

    # And I answer Yes to the additional respondents question
    step_six_page.more_than_one_employer.set("Yes")

    # And I fill in the second respondent's details with:
    table_hashes = [
        {'field' => 'name', 'value' => 'Respondent Two'},
        {'field' => 'building', 'value' => '112'},
        {'field' => 'street', 'value' => 'Oxford Street'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H 9UV'},
        {'field' => 'acas_number', 'value' => 'AC654321/87/09'}
    ]

    table_hashes.each do |hash|
      step_six_page.more_than_one_employer.respondent_two do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
        end
      end
    end

    # And I choose to add another respondent
    step_six_page.more_than_one_employer.add_another_respondent.click

    # And I fill in the third respondent's details with:
    table_hashes = [
        {'field' => 'name', 'value' => 'Respondent Three'},
        {'field' => 'building', 'value' => '114'},
        {'field' => 'street', 'value' => 'Knightsbridge'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H 9WX'},
        {'field' => 'acas_number', 'value' => 'AC654321/88/10'}
    ]
    table_hashes.each do |hash|
      step_six_page.more_than_one_employer.respondent_three do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
        end
      end
    end

    # And I choose to add another respondent
    step_six_page.more_than_one_employer.add_another_respondent.click

    # And I fill in the fourth respondent's details with:
    table_hashes = [
        {'field' => 'name', 'value' => 'Respondent Four'},
        {'field' => 'building', 'value' => '116'},
        {'field' => 'street', 'value' => 'Mayfair'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H 9YZ'},
        {'field' => 'acas_number', 'value' => 'AC654321/88/10'}
    ]
    table_hashes.each do |hash|
      step_six_page.more_than_one_employer.respondent_four do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
        end
      end
    end

    # And I choose to add another respondent
    step_six_page.more_than_one_employer.add_another_respondent.click

    # And I fill in the fifth respondent's details with:
    table_hashes = [
        {'field' => 'name', 'value' => 'Respondent Five'},
        {'field' => 'building', 'value' => '118'},
        {'field' => 'street', 'value' => 'Marylebone Road'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H 8AB'},
        {'field' => 'acas_number', 'value' => 'AC654321/89/11'}
    ]
    table_hashes.each do |hash|
      step_six_page.more_than_one_employer.respondent_five do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
        end
      end
    end

    # And I save the additional respondents
    step_six_page.save_and_continue.click

    # And I answer Yes to the have you ever been employed by the person you are making the claim against question
    step_seven_page.your_employment_details.set("Yes")

    # And I answer "Still working for this employer" to the current work situation question
    step_seven_page.your_employment_details.current_work_situation.set('Still working for this employer')

    # And I fill in the employment details with:
    table_hashes = [
        {'field' => 'job_title', 'value' => 'Project Manager'},
        {'field' => 'start_date', 'value' => '18/11/2009'},
        {'field' => 'notice_period', 'value' => 'Yes'},
        {'field' => 'notice_period_value', 'value' => '3 Months'},
        {'field' => 'average_weekly_hours', 'value' => '38'}
    ]
    table_hashes.each do |hash|
      step_seven_page.your_employment_details.employment_details do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
        end
      end
    end

    # And I fill in the pay, pension and benefits with:
    table_hashes = [
        {'field' => 'pay_before_tax', 'value' => '3000 Monthly'},
        {'field' => 'pay_after_tax', 'value' => '2000 Monthly'},
        {'field' => 'employers_pension_scheme', 'value' => 'Yes'},
        {'field' => 'benefits', 'value' => 'Company car, private health care'}
    ]
    table_hashes.each do |hash|
      step_seven_page.your_employment_details.pay_pension_benefits do |section|
        node = section.send((hash['field']).to_s.to_sym)
        case node.try(:tag_name)
        when "select" then node.select(hash['value'])
        else node.set(hash['value'])
        end
      end
    end

    # And I save the employment details
    step_seven_page.save_and_continue.click

    # And I answer "Unfair dismissal (including constructive dismissal)" to the about the claim question
    step_eight_page.claim_type.set("Unfair dismissal (including constructive dismissal)")

    # And I answer Yes to the whistleblowing claim question
    step_eight_page.whistleblowing_claim.set("Yes")

    # And I answer Yes to the send copy to relevant person that deals with whistleblowing question
    step_eight_page.whistleblowing_claim.send_to_relevant_person.set("Yes")

    # And I save the claim type
    step_eight_page.save_and_continue.click

    # And I fill in the claim description with "Full text version of claim"
    step_nine_page.description.set('Full text version of claim')

    # And I answer Yes to the similar claims question
    step_nine_page.similar_claims.other_claimants.set('Yes')

    # And I fill in the similar claim names with "Similar Claim1, Similar Claim2"
    step_nine_page.similar_claims.names.set('Similar Claim1, Similar Claim2')

    # And I save the claim details
    step_nine_page.save_and_continue.click

    # And I answer "Compensation" to the preferred outcome question
    step_ten_page.preferred_outcome.set('Compensation')

    # And I fill in the compensation field with "I would like 50,000 GBP due to the stress this caused me"
    step_ten_page.preferred_outcome.notes.set('I would like 50,000 GBP due to the stress this caused me')

    # And I save the claim outcome
    step_ten_page.save_and_continue.click

    # And I answer Yes to the other important details question
    step_eleven_page.other_important_details.set("Yes")

    # And I fill in the important details with "Here are some very important details that need to be considered"
    step_eleven_page.other_important_details.notes.set('Here are some very important details that need to be considered')

    # And I save the more about the claim form
    step_eleven_page.save_and_continue.click

    # And I submit my claim
    submission_page.submit_claim.click

    # And all background jobs for claim submissions are processed
    perform_enqueued_jobs do
      jobs = queue_adapter.enqueued_jobs.select { |job_spec| job_spec[:job] == ClaimSubmissionJob }
      jobs.each do |job_spec|
        job_spec[:job].perform_now(*ActiveJob::Arguments.deserialize(job_spec[:args]))
      end
    end

    # And I save a copy of my claim
    claim_submitted_page.save_a_copy

    # Then the claim pdf file's Your details section should contain:
    table_hashes = [
        {'field' => 'title', 'value' => 'Mr'},
        {'field' => 'first_name', 'value' => 'First'},
        {'field' => 'last_name', 'value' => 'Last'},
        {'field' => 'date_of_birth', 'value' => '21/11/1982'},
        {'field' => 'gender', 'value' => 'Male'},
        {'field' => 'building', 'value' => '102'},
        {'field' => 'street', 'value' => 'Petty France'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H9AJ'},
        {'field' => 'telephone_number', 'value' => '01234 567890'},
        {'field' => 'alternative_telephone_number', 'value' => '01234 098765'},
        {'field' => 'email_address', 'value' => 'test@digital.justice.gov.uk'},
        {'field' => 'correspondence', 'value' => 'Email'},
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.your_details.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Respondent's details name section should contain:
    table_hashes = [
        { 'field' => 'name', 'value' => 'Respondent Name'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.respondents_details.name.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Respondent's details address section should contain:
    table_hashes = [
        {'field' => 'building', 'value' => '108'},
        {'field' => 'street', 'value' => 'Regent Street'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H9QR'},
        {'field' => 'telephone_number', 'value' => '02222 321654'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.respondents_details.address.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Respondent's details acas section should contain:
    table_hashes = [
        {'field' => 'have_acas', 'value' => 'Yes'},
        {'field' => 'acas_number', 'value' => 'AC123456/78/90'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.respondents_details.acas.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Respondent's details different address section should contain:
    table_hashes = [
        {'field' => 'building', 'value' => '110'},
        {'field' => 'street', 'value' => 'Piccadily Circus'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H9ST'},
        {'field' => 'telephone_number', 'value' => '03333 423554'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.respondents_details.different_address.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Respondent's details second respondent name section should contain:
    table_hashes = [
        {'field' => 'name', 'value' => 'Respondent Two'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.respondents_details.respondent_two.name.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Respondent's details second respondent address section should contain:
    table_hashes = [
        {'field' => 'building', 'value' => '112'},
        {'field' => 'street', 'value' => 'Oxford Street'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.respondents_details.respondent_two.address.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Respondent's details second respondent acas section should contain:
    table_hashes = [
        {'field' => 'have_acas', 'value' => 'Yes'},
        {'field' => 'acas_number', 'value' => 'AC654321/87/09'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.respondents_details.respondent_two.acas.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Respondent's details third respondent name section should contain:
    table_hashes = [
        {'field' => 'name', 'value' => 'Respondent Three'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.respondents_details.respondent_three.name.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Respondent's details third respondent address section should contain:
    table_hashes = [
        {'field' => 'building', 'value' => '114'},
        {'field' => 'street', 'value' => 'Knightsbridge'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H9WX'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.respondents_details.respondent_three.address.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Respondent's details third respondent acas section should contain:
    table_hashes = [
        {'field' => 'have_acas', 'value' => 'Yes'},
        {'field' => 'acas_number', 'value' => 'AC654321/88/10'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.respondents_details.respondent_three.acas.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Multiple cases section should contain:
    table_hashes = [
        {'field' => 'have_similar_claims', 'value' => 'Yes'},
        {'field' => 'other_claimants', 'value' => 'Similar Claim1, Similar Claim2'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.multiple_cases.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Respondent not your employer section should contain:
    table_hashes = [
        {'field' => 'claim_type', 'value' => ''}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.respondent_not_your_employer.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Respondent Employment details section should contain:
    table_hashes = [
        {'field' => 'job_title', 'value' => 'Project Manager'},
        {'field' => 'start_date', 'value' => '18/11/2009'},
        {'field' => 'employment_continuing', 'value' => 'Yes'},
        {'field' => 'ended_date', 'value' => ''},
        {'field' => 'ending_date', 'value' => ''}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.employment_details.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Respondent Earnings and benefits section should contain:
    table_hashes = [
        {'field' => 'average_weekly_hours', 'value' => '38.0'},
        {'field' => 'pay_before_tax', 'value' => '3000 Monthly'},
        {'field' => 'pay_after_tax', 'value' => '2000 Monthly'},
        {'field' => 'paid_for_notice_period', 'value' => 'No'},
        {'field' => 'notice_period', 'value' => ''},
        {'field' => 'employers_pension_scheme', 'value' => 'Yes'},
        {'field' => 'benefits', 'value' => 'Company car, private health care'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.earnings_and_benefits.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's What happened since section should contain:
    table_hashes = [
        {'field' => 'have_another_job', 'value' => 'No'},
        {'field' => 'start_date', 'value' => ''},
        {'field' => 'salary', 'value' => ''}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.what_happened_since.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Type and details of claim section should contain:
    table_hashes = [
        {'field' => 'unfairly_dismissed', 'value' => 'Yes'},
        {'field' => 'discriminated_age', 'value' => 'No'},
        {'field' => 'discriminated_race', 'value' => 'No'},
        {'field' => 'discriminated_gender_reassignment', 'value' => 'No'},
        {'field' => 'discriminated_disability', 'value' => 'No'},
        {'field' => 'discriminated_pregnancy', 'value' => 'No'},
        {'field' => 'discriminated_marriage', 'value' => 'No'},
        {'field' => 'discriminated_sexual_orientation', 'value' => 'No'},
        {'field' => 'discriminated_sex', 'value' => 'No'},
        {'field' => 'discriminated_religion', 'value' => 'No'},
        {'field' => 'claiming_redundancy_payment', 'value' => 'No'},
        {'field' => 'owed_notice_pay', 'value' => 'No'},
        {'field' => 'owed_holiday_pay', 'value' => 'No'},
        {'field' => 'owed_arrears_of_pay', 'value' => 'No'},
        {'field' => 'owed_other_payments', 'value' => 'No'},
        {'field' => 'other_type_of_claim', 'value' => 'No'},
        {'field' => 'other_type_of_claim_details', 'value' => ''},
        {'field' => 'claim_description', 'value' => 'Full text version of claim'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.type_and_details_of_claim.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's What do you want section should contain:
    table_hashes = [
        {'field' => 'prefer_re_instatement', 'value' => 'No'},
        {'field' => 'prefer_re_engagement', 'value' => 'No'},
        {'field' => 'prefer_compensation', 'value' => 'Yes'},
        {'field' => 'prefer_recommendation', 'value' => 'No'},
        {'field' => 'compensation', 'value' => 'I would like 50,000 GBP due to the stress this caused me'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.what_do_you_want.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Information to regulators section should contain:
    table_hashes = [
        {'field' => 'whistle_blowing', 'value' => 'Yes'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.information_to_regulators.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Your representative section should contain:
    table_hashes = [
        {'field' => 'name_of_organisation', 'value' => 'Solicitors Are Us Fake Company'},
        {'field' => 'name_of_representative', 'value' => 'Solicitor Name'},
        {'field' => 'building', 'value' => '106'},
        {'field' => 'street', 'value' => 'Mayfair'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H9PP'},
        {'field' => 'dx_number', 'value' => 'dx1234567890'},
        {'field' => 'telephone_number', 'value' => '01111 123456'},
        {'field' => 'alternative_telephone_number', 'value' => '02222 654321'},
        {'field' => 'reference', 'value' => ''},
        {'field' => 'email_address', 'value' => 'solicitor.test@digital.justice.gov.uk'},
        {'field' => 'communication_preference', 'value' => ''},
        {'field' => 'fax_number', 'value' => ''}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.your_representative.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Disability section should contain:
    table_hashes = [
        {'field' => 'has_special_needs', 'value' => 'Yes'},
        {'field' => 'special_needs', 'value' => 'My special needs are as follows'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.disability.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Additional respondents section should contain the following for respondent 4:
    table_hashes = [
        {'field' => 'name', 'value' => 'Respondent Four'},
        {'field' => 'building', 'value' => '116'},
        {'field' => 'street', 'value' => 'Mayfair'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H9YZ'},
        {'field' => 'telephone_number', 'value' => ''},
        {'field' => 'have_acas', 'value' => 'Yes'},
        {'field' => 'acas_number', 'value' => 'AC654321/88/10'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.additional_respondents.respondent_four.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Additional respondents section should contain the following for respondent 5:
    table_hashes = [
        {'field' => 'name', 'value' => 'Respondent Five'},
        {'field' => 'building', 'value' => '118'},
        {'field' => 'street', 'value' => 'Marylebone Road'},
        {'field' => 'locality', 'value' => 'London'},
        {'field' => 'county', 'value' => 'Greater London'},
        {'field' => 'post_code', 'value' => 'SW1H8AB'},
        {'field' => 'telephone_number', 'value' => ''},
        {'field' => 'have_acas', 'value' => 'Yes'},
        {'field' => 'acas_number', 'value' => 'AC654321/89/11'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.additional_respondents.respondent_five.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Final check section should contain:
    table_hashes = [
        {'field' => 'satisfied', 'value' => 'No'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.final_check.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end

    # And the claim pdf file's Additional information section should contain:
    table_hashes = [
        {'field' => 'additional_information', 'value' => 'Here are some very important details that need to be considered'}
    ]
    claim_submitted_page.within_popup_window do
      pdf_page = ::ET1::Test::ClaimSubmittedPdfPage.new
      expect(pdf_page).to be_displayed
      table_hashes.each do |hash|
        expect(pdf_page.pdf_document.additional_information.send(hash['field'].to_sym).value).to eql hash['value']
      end
    end









  end
end


