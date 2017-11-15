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

    test_user.et_case = OpenStruct.new respondent: resp
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
