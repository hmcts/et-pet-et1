module FormMethods
  SAVE_AND_RETURN_EMAIL = 'mail@example.com'
  CLAIMANT_EMAIL = 'barrington@example.com'
  REPRESENTATIVE_EMAIL = 'rep@example.com'

  extend ActiveSupport::Concern

  included do
    let(:fgr_response) do
      {
        "fgr"               => 511234567800,
        "ETOfficeCode"      => 22,
        "ETOfficeName"      => "Birmingham",
        "ETOfficeAddress"   => "Centre City Tower, 5­7 Hill Street, Birmingham B5 4UU",
        "ETOfficeTelephone" => "0121 600 7780"
      }
    end

    let(:submission_response) do
      {
        "feeGroupReference" => 511234567800,
        "status" => 'ok'
      }
    end

    before do
      stub_request(:post, 'https://etapi.employmenttribunals.service.gov.uk/1/new-claim').
        to_return(body: submission_response.to_json, headers: { 'Content-Type' => 'application/json' })

      stub_request(:post, 'https://etapi.employmenttribunals.service.gov.uk/1/fgr-et-office').
        with(postcode: 'AT1 4PQ').
        to_return(body: fgr_response.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    around do |example|
      stub_request(:get, "https://mdepayments.epdq.co.uk/ncol/test/backoffice?BRANDING=EPDQ&lang=1").
        to_return(:status => 200, :body => "", :headers => {})

      PaymentGateway::TASK.run
      example.run
      PaymentGateway::TASK.stop
    end
  end

  def start_claim
    visit '/'
    click_button 'Start a claim'
  end

  def end_session
    click_button 'Save and complete later'
    click_button 'Sign out now'
  end

  def fill_in_return_form(reference, word)
    visit new_user_session_path
    fill_in 'Claim number', with: reference
    fill_in 'Memorable word', with: word
    click_button 'Find my claim'
  end

  def fill_in_password(word='green')
    fill_in_password_and_email(word, nil)
  end

  def fill_in_password_and_email(word='green', email_address=SAVE_AND_RETURN_EMAIL, email_address_element='email_address')
    fill_in 'Create your memorable word', with: word
    fill_in email_address_element, with: email_address if email_address.present?

    click_button 'Save and continue'
  end

  def fill_in_personal_details(options = {})
    select 'Mr', from: 'Title'

    fill_in 'First name', with: 'Barrington'
    fill_in 'Last name',  with: 'Wrigglesworth'

    choose 'Male'

    fill_in 'Day',   with: '15'
    fill_in 'Month', with: '01'
    fill_in 'Year',  with: '1985'

    fill_in_address

    fill_in 'Alternative phone',   with: '07956000000'

    if options[:claimant_email] == false
      choose 'claimant_contact_preference_post'
    else
      choose  'claimant_contact_preference_email'
      fill_in 'Email address', with: CLAIMANT_EMAIL
    end

    choose  'claimant_has_special_needs_true'
    fill_in 'Describe the assistance you require', with: 'I am blind.'

    click_button 'Save and continue' unless options[:submit_form] == false
  end

  def fill_in_additional_claimant_details
    choose "No"
    click_button 'Save and continue'
  end

  def fill_in_additional_claimant_jump_to_csv_upload
    choose "Yes"
    click_link "spreadsheet"
  end

  def fill_in_additional_claimants_upload_details
    choose "No"
    click_button "Save and continue"
  end

  def fill_in_representative_details
    choose 'representative_has_representative_true'
    select 'Solicitor', from: 'representative_type'
    fill_in "Name of the representative’s organisation", with: 'Better Call Saul'
    fill_in "Representative’s name", with: 'Saul Goodman'

    fill_in_address

    fill_in 'Alternative phone',   with: '07956000000'
    fill_in 'Email address', with: REPRESENTATIVE_EMAIL
    fill_in 'Document exchange (DX) number', with: '1'

    click_button 'Save and continue'
  end

  def fill_in_address
    fill_in 'Building number or name', with: '1'
    fill_in 'Street',                  with: 'High street'
    fill_in 'Town/city',               with: 'Anytown'
    fill_in 'County',                  with: 'Anyfordshire'
    fill_in 'Postcode',                with: 'AT1 4PQ'
    fill_in 'Phone',                   with: '01234567890'
  end

  def fill_in_respondent_details
    fill_in 'Name', with: 'Crappy Co, LTD'

    fill_in :respondent_address_building,         with: '2'
    fill_in :respondent_address_street,           with: 'Main street'
    fill_in :respondent_address_locality,         with: 'Anytown'
    fill_in :respondent_address_county,           with: 'Anyfordshire'
    fill_in :respondent_address_post_code,        with: 'AT3 0AS'
    fill_in :respondent_address_telephone_number, with: '01234567890'

    choose 'respondent_worked_at_same_address_false'

    within('.work-address') { fill_in_address }

    check  "I don’t have an Acas number"
    choose 'respondent_no_acas_number_reason_acas_has_no_jurisdiction'

    click_button 'Save and continue'
  end

  def fill_in_additional_respondent_details
    choose "No"
    click_button 'Save and continue'
  end

  def fill_in_employment_details
    choose  'employment_was_employed_true'

    fill_in 'Job title', with: 'Super High Powered Exec'

    within '.employment_start_date' do
      fill_in 'Day',   with: '01'
      fill_in 'Month', with: '07'
      fill_in 'Year',  with: '2000'
    end

    fill_in :employment_average_hours_worked_per_week, with: 37.5
    fill_in 'Pay before tax', with: 10000
    choose  'employment_gross_pay_period_type_weekly'
    fill_in 'Pay after tax',  with: 6000
    choose  'employment_net_pay_period_type_weekly'

    click_button 'Save and continue'
  end

  def fill_in_pre_claim_pages
    start_claim
    fill_in_password
    fill_in_personal_details
    fill_in_additional_claimant_details
    fill_in_representative_details
    fill_in_respondent_details
    fill_in_additional_respondent_details
    fill_in_employment_details
  end

  def fill_in_claim_type_details
    check "Unfair dismissal (including constructive dismissal)"
    label = find('label', text: "Sex (including equal pay)")
    find("##{label['for']}").set true
    check 'Other type of claim'
    fill_in :claim_type_other_claim_details,
      with: 'Boss was a bit of a douchenozzle TBH'
    choose 'claim_type_is_whistleblowing_true'
    choose 'claim_type_send_claim_to_whistleblowing_entity_true'

    click_button 'Save and continue'
  end

  def fill_in_claim_details
    fill_in 'claim_details_claim_details',
      with: "Everybody hates me"
    choose 'claim_details_other_known_claimants_true'
    fill_in 'You can add the names of other people here. (optional)',
      with: 'Charles, Faz & Stevie'

    click_button 'Save and continue'
  end

  def fill_in_claim_outcome_details
    label = find('label', text: "Compensation")
    find("##{label['for']}").set true
    fill_in 'What compensation or other outcome do you want? (optional)',
      with: 'i would like a gold chain'

    click_button 'Save and continue'
  end

  def fill_in_addtional_information
    choose 'additional_information_has_miscellaneous_information_true'
    fill_in 'additional_information_miscellaneous_information',
      with: 'better late than never'

    click_button 'Save and continue'
  end

  def fill_in_your_fee(options={})
    choose "your_fee_applying_for_remission_#{options.fetch(:seeking_remissions) { false }}"

    click_button 'Save and continue'
  end

  def complete_payment(gateway_response: 'success')
    path = "/apply/pay/#{gateway_response}?orderID=511234567800&amount=250&PM=CreditCard&" +
      'ACCEPTANCE=test123&STATUS=9&CARDNO=XXXXXXXXXXXX111&TRXDATE=09%2F15%2F14&' +
      'PAYID=34707458&NCERROR=0&BRAND=VISA&' +
      'SHASIGN=A8410E130DA5C6AB210CF8E64CAFA64EC8AC8EFF0D958AC0D2CB3AF3EE467E75'

    visit path
  end

  def complete_a_claim(options={})
    start_claim
    fill_in_password
    fill_in_personal_details(options)
    fill_in_additional_claimant_details
    fill_in_representative_details
    fill_in_respondent_details
    fill_in_additional_respondent_details
    fill_in_employment_details
    fill_in_claim_type_details
    fill_in_claim_details
    fill_in_claim_outcome_details
    fill_in_addtional_information
    fill_in_your_fee(options)
  end

  def complete_and_submit_claim
    complete_a_claim
    click_button "Submit claim"
    complete_payment
  end

  def deselect_claimant_email
    uncheck CLAIMANT_EMAIL
  end

  def deselect_representative_email
    uncheck REPRESENTATIVE_EMAIL
  end

  def block_pdf_generation
    Claim.last.remove_pdf!
  end
end
