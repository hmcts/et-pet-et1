
Given(/^I am "Luke Skywalker"$/) do
  address = OpenStruct.new building: '102',
                           street: 'Petty France',
                           locality: 'London',
                           county: 'Greater London',
                           post_code: 'SW1H 9AJ',
                           country: 'United Kingdom'
  bank_account = OpenStruct.new account_name: 'Mr Luke Skywalker',
                                bank_name: 'Starship Enterprises Bank',
                                account_number: '12345678',
                                sort_code: '012345'
  self.test_user = OpenStruct.new title: "Mr",
                                  first_name: "Luke",
                                  last_name: "Skywalker",
                                  date_of_birth: '21/11/1985',
                                  address: address,
                                  telephone_number: '01234 567890',
                                  email_address: 'test@digital.justice.gov.uk',
                                  bank_account: bank_account
end
