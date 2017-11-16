Given(/^I am "Luke Skywalker"$/) do
  address = OpenStruct.new building: '102',
                           street: 'Petty France',
                           locality: 'London',
                           county: 'Greater London',
                           post_code: 'SW1H9AJ'
  self.test_user = OpenStruct.new title: "Mr",
                                  first_name: "Luke",
                                  last_name: "Skywalker",
                                  date_of_birth: '21/11/1985',
                                  address: address,
                                  telephone_number: '01234 567890',
                                  email_address: 'test@digital.justice.gov.uk',
                                  gender: 'Male',
                                  correspondence: 'Email'
end

Given(/^I am "Anakin Skywalker"$/) do
  address = OpenStruct.new building: '102',
                           street: 'Petty France',
                           post_code: 'SW1H 9AJ'
  self.test_user = OpenStruct.new title: "Mr",
                                  first_name: "Luke",
                                  last_name: "Skywalker",
                                  date_of_birth: '21/11/1985',
                                  address: address,
                                  telephone_number: '01234 567890',
                                  alternative_telephone_number: '01234 098765'
end


And(/^I have special needs for an employee tribunal$/) do
  test_user.et_case.special_needs = "My special needs are as follows"
end


And(/^I prefer email correspondence for an employee tribunal$/) do
  test_user.correspondence = 'Email'
end


And(/^I want (\d+) group claimaints for an employee tribunal$/) do |qty_string|
  qty = qty_string.to_i
  test_user.et_case.group_claimants = []
  qty.times do |idx|
    claimant = OpenStruct.new title: 'Mr',
                              first_name: "Claimant#{idx + 2}",
                              last_name: 'Last',
                              date_of_birth: '25/12/1989',
                              building: idx.to_s,
                              street: 'Oxford Street',
                              locality: 'London',
                              county: 'Greater London',
                              post_code: "SW1H #{idx}JA"
    test_user.et_case.group_claimants << claimant
  end
end


And(/^I want to apply for an employee tribunal/) do
  resp = OpenStruct.new name: 'Respondent Name',
                        building: '108',
                        street: 'Regent Street',
                        locality: 'London',
                        county: 'Greater London',
                        post_code: 'SW1H 9QR',
                        telephone_number: '02222 321654'

  test_user.et_case = OpenStruct.new respondent: resp,
                                     claim_types: {},
                                     claim_description: 'Full text version of claim'
end


And(/^I want a representative for an employee tribunal$/) do
  address = OpenStruct.new building: '106',
                           street: 'Mayfair',
                           locality: 'London',
                           county: 'Greater London',
                           post_code: 'SW1H 9PP'
  rep = OpenStruct.new type: 'Solicitor',
                       organisation_name: 'Solicitors Are Us Fake Company',
                       name: 'Solicitor Name',
                       address: address,
                       telephone_number: '01111 123456',
                       alternative_telephone_number: '02222 654321',
                       email_address: 'solicitor.test@digital.justice.gov.uk',
                       dx_number: 'dx1234567890'
  test_user.et_case.representative = rep
end


And(/^I worked at a different address to the respondent address for an employee tribunal$/) do
  work_address = OpenStruct.new building: '110',
                                street: 'Piccadily Circus',
                                locality: 'London',
                                county: 'Greater London',
                                post_code: 'SW1H 9ST',
                                telephone_number: '03333 423554'

  test_user.et_case.worked_at_respondent_address = 'No'
  test_user.et_case.work_address = work_address
end


And(/^I want (\d+) additional respondents for an employee tribunal$/) do |qty_str|
  qty = qty_str.to_i
  test_user.et_case.additional_respondents = []
  qty.times do |idx|
    respondent = OpenStruct.new name: "Respondent#{idx + 2} Surname",
                                building: (idx + 2).to_s,
                                street: 'Oxford Street',
                                locality: 'London',
                                county: 'Greater London',
                                post_code: "SW1H #{idx + 2}UV",
                                acas_number: "AC654321/87/0#{idx + 2}"

    test_user.et_case.additional_respondents << respondent
  end

end


And(/^I worked as a project manager for the respondent for an employee tribunal$/) do
  test_user.et_case.employment = OpenStruct.new job_title: 'Project Manager',
                                                start_date: '18/11/2009',
                                                notice_period: 'Yes',
                                                notice_period_value: '3 Months',
                                                average_weekly_hours: '38',
                                                pay_before_tax: '3000 Monthly',
                                                pay_after_tax: '2000 Monthly',
                                                employers_pension_scheme: 'Yes',
                                                benefits: 'Company car, private health care'

end


And(/^I want to claim for unfair dismissal in my employee tribunal$/) do
  test_user.et_case.claim_types['Unfair dismissal (including constructive dismissal)'] = 'Yes'
end


And(/^I want to blow the whistle on someone in my employee tribunal$/) do
  test_user.et_case.whistleblowing_claim = 'Yes'
end


And(/^I want to send the whistleblowing claim to the relevant person in my employee tribunal$/) do
  test_user.et_case.send_whistleblowing_claim_to_relevant_person
end


And(/^I know about 2 similar claims for my employment tribunal$/) do
  test_user.et_case.similar_claims = ['Similar Claim1', 'Similar Claim2']
end
