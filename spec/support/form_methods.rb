module FormMethods
  SAVE_AND_RETURN_EMAIL = 'mail@example.com'
  CLAIMANT_EMAIL = 'barrington@example.com'
  REPRESENTATIVE_EMAIL = 'rep@example.com'

  def start_claim
    visit '/'
    click_button 'Apply now'
  end

  def end_session
    click_button 'Complete later'
    click_button 'Sign out now'
  end

  def fill_in_return_form reference, word
    visit '/user_sessions/new'
    fill_in 'reference', with: reference
    fill_in 'memorable word', with: word
    click_button 'Next'
  end

  def fill_in_password(word='green')
    fill_in_password_and_email(word, nil)
  end

  def fill_in_password_and_email(word='green', email=SAVE_AND_RETURN_EMAIL)
    fill_in 'memorable word', with: word
    fill_in 'Email address', with: email if email.present?

    click_button 'Save and continue'
  end

  def fill_in_personal_details(submit_form: true)
    select 'Mr', from: 'Title'

    fill_in 'First name', with: 'Barrington'
    fill_in 'Last name',  with: 'Wrigglesworth'

    choose 'Male'

    fill_in :claimant_date_of_birth_3i, with: '15'
    fill_in :claimant_date_of_birth_2i, with: '01'
    fill_in :claimant_date_of_birth_1i, with: '1985'

    fill_in_address

    fill_in 'Alternative phone',   with: '07956000000'

    choose  'claimant_contact_preference_email'
    fill_in 'Email address', with: CLAIMANT_EMAIL

    choose  'claimant_has_special_needs_true'
    fill_in 'Tell us how we can help you.', with: 'I am blind.'

    click_button 'Save and continue' if submit_form
  end

  def fill_in_representative_details
    select 'Solicitor', from: 'Type of representative'
    fill_in "Name of the representative's organisation", with: 'Better Call Saul'
    fill_in "Representative's name", with: 'Saul Goodman'

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

  def fill_in_employer_details
    fill_in 'Name', with: 'Crappy Co, LTD'

    fill_in :respondent_address_building,         with: '2'
    fill_in :respondent_address_street,           with: 'Main street'
    fill_in :respondent_address_locality,         with: 'Anytown'
    fill_in :respondent_address_county,           with: 'Anyfordshire'
    fill_in :respondent_address_post_code,        with: 'AT3 0AS'
    fill_in :respondent_address_telephone_number, with: '01234567890'

    choose 'respondent_worked_at_different_address_true'

    within('.work-address') { fill_in_address }

    check  "I don't have an Acas number"
    choose 'respondent_no_acas_number_reason_acas_has_no_jurisdiction'

    # choose 'respondent_was_employed_true'

    click_button 'Save and continue'
  end

  def fill_in_employment_details
    fill_in 'Job or job title', with: 'Super High Powered Exec'

    fill_in :employment_start_date_3i, with: '01'
    fill_in :employment_start_date_2i, with: '07'
    fill_in :employment_start_date_1i, with: '2000'

    fill_in 'Average hours worked each week', with: 37.5
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
    fill_in_representative_details
    fill_in_employer_details
    fill_in_employment_details
  end

  def fill_in_claim_type_details
    check "Unfair dismissal (including constructive dismissal)"
    label = find('label', text: "Sex (including equal pay)")
    find("##{label['for']}").set true
    check 'Another type of claim'
    fill_in 'State the other type of claim – or claims – that you’re making',
      with: 'Boss was a bit of a douchenozzle TBH'
    choose 'claim_type_is_whistleblowing_true'
    choose 'claim_type_send_claim_to_whistleblowing_entity_true'

    click_button 'Save and continue'
  end

  def fill_in_claim_details
    fill_in 'This is your opportunity to tell us about your problem at work.',
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

  def fill_in_your_fee seeking_remissions: false
    choose "your_fee_applying_for_remission_#{seeking_remissions}"

    click_button 'Save and continue'
  end

  def return_from_payment_gateway(response='success')
    visit "/apply/pay/#{response}?orderID=fgr&amount=250&PM=CreditCard&" +
      'ACCEPTANCE=test123&STATUS=9&CARDNO=XXXXXXXXXXXX111&TRXDATE=09%2F15%2F14&' +
      'PAYID=34707458&NCERROR=0&BRAND=VISA&' +
      'SHASIGN=33A55FEF5AA437A1512CFBA7AC91AF4B112A4C1AD1CD02609895EC05CFCD40B9'
  end

  def complete_a_claim(options={})
    start_claim
    fill_in_password
    fill_in_personal_details
    fill_in_representative_details
    fill_in_employer_details
    fill_in_employment_details
    fill_in_claim_type_details
    fill_in_claim_details
    fill_in_claim_outcome_details
    fill_in_addtional_information
    fill_in_your_fee(options)
  end

  def select_recipients
    check CLAIMANT_EMAIL
    check REPRESENTATIVE_EMAIL
    fill_in 'additional_email_address_1', with: 'bob@example.com'
    fill_in 'additional_email_address_2', with: 'jane@example.com'
    click_button 'Submit the form'
  end
end
