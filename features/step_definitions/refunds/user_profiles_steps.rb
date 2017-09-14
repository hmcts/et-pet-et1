
Given(/^I am "Luke Skywalker"$/) do
  address = OpenStruct.new building: '102',
                           street: 'Petty France',
                           locality: 'London',
                           county: 'Greater London',
                           post_code: 'SW1H 9AJ',
                           country: 'United Kingdom'
  self.test_user = OpenStruct.new title: "Mr",
                                  first_name: "Luke",
                                  last_name: "Skywalker",
                                  date_of_birth: '21/11/1985',
                                  address: address,
                                  telephone_number: '01234 567890',
                                  email_address: 'test@digital.justice.gov.uk'
end
# And I fill in my refund claimant details with:
# | field         | value      |
# | title         | Mr         |
# | first_name    | First      |
# | last_name     | Last       |
# | date_of_birth | 21/11/1982 |
#   And I fill in my refund claimant contact details with:
# | field            | value                       |
# | building         | 102                         |
# | street           | Petty France                |
# | locality         | London                      |
# | county           | Greater London              |
# | post_code        | SW1H 9AJ                    |
# | country          | United Kingdom              |
# | telephone_number | 01234 567890                |
# | email_address    | test@digital.justice.gov.uk |
