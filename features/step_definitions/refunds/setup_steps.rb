Given(/^I am "Luke Skywalker"$/) do
  address = OpenStruct.new building: '102',
                           street: 'Petty France',
                           locality: 'London',
                           county: 'Greater London',
                           post_code: 'SW1H 9AJ'
  self.test_user = OpenStruct.new title: "Mr",
                                  first_name: "Luke",
                                  last_name: "Skywalker",
                                  date_of_birth: '21/11/1985',
                                  address: address,
                                  telephone_number: '01234 567890',
                                  email_address: 'test@digital.justice.gov.uk'
end

And(/^I want a refund for my previous ET claim with case number "1234567\/2016"$/) do
  respondent_address = OpenStruct.new post_code: 'SW1H 9QR',
                                      building: '106',
                                      street: 'Petty France',
                                      locality: 'London',
                                      county: 'Greater London'

  respondent = OpenStruct.new name: 'Respondent Name',
                              address: respondent_address


  fees = OpenStruct.new et_issue_fee: '1000.00',
                        et_issue_payment_method: 'Card',
                        et_issue_payment_date: '1/2016',
                        et_hearing_fee: '1001.00',
                        et_hearing_payment_method: 'Cash',
                        et_hearing_payment_date: '2/2016',
                        eat_issue_fee: '1002.00',
                        eat_issue_payment_method: 'Cheque',
                        eat_issue_payment_date: '3/2016',
                        eat_hearing_fee: '1003.00',
                        eat_hearing_payment_method: 'Card',
                        eat_hearing_payment_date: '4/2016',
                        et_reconsideration_fee: '1004.00',
                        et_reconsideration_payment_method: 'Card',
                        et_reconsideration_payment_date: 'Don\'t know'

  test_user.et_claim_to_refund = OpenStruct.new et_case_number: '1234567/2016',
                                                et_tribunal_office: 'Newcastle',
                                                additional_information: 'REF1, REF2, REF3',
                                                respondent: respondent.freeze,
                                                fees: fees.freeze,
                                                et_country_of_claim: 'England & Wales'

end


And(/^I have a bank account$/) do
  test_user.bank_account = OpenStruct.new account_name: 'Mr Luke Skywalker',
                                          bank_name: 'Starship Enterprises Bank',
                                          account_number: '12345678',
                                          sort_code: '012345'
end

And(/^I have a building society account$/) do
  test_user.building_society_account = OpenStruct.new account_name: 'Mr Luke Skywalker',
                                                      building_society_name: 'Starship Enterprises Building Society',
                                                      account_number: '12345678',
                                                      sort_code: '012345'
end


And(/^my name has not changed since the original claim that I want a refund for$/) do
  test_user.has_name_changed = 'No'
end


And(/^my address has not changed since the original claim that I want a refund for$/) do
  test_user.claim_address_changed = 'No'
  test_user.et_claim_to_refund.address = test_user.address
end

And(/^my address has changed since the original claim that I want a refund for$/) do
  test_user.claim_address_changed = 'Yes'
  test_user.et_claim_to_refund.address = OpenStruct.new building: '104',
                                                        street: 'Petty Belgium',
                                                        locality: 'London',
                                                        county: 'Greater London',
                                                        post_code: 'SW1H 9BK'
end


And(/^I did not have a representative$/) do
  test_user.et_claim_to_refund.has_representative = 'No'
  test_user.et_claim_to_refund.representative = nil
end

And(/^I had a representative$/) do
  representative_address = OpenStruct.new post_code: 'SW2H 9ST',
                                          building: '108',
                                          street: 'Petty France',
                                          locality: 'London',
                                          county: 'Greater London'

  representative = OpenStruct.new name: 'Representative Name',
                                  address: representative_address

  test_user.et_claim_to_refund.has_representative = 'Yes'
  test_user.et_claim_to_refund.representative = representative
end
