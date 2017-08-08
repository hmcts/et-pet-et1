Feature: Output Form
  Scenario: Scenario 1
    Given I am on the new claim page
    And I start a new claim
    And I save my claim with a valid email address and password
    And I fill in my claimant details with:
      | field                         | value                                 |
      | title                         | Mr                                    |
      | first_name                    | First                                 |
      | last_name                     | Last                                  |
      | date_of_birth                 | 21/11/1982                            |
      | gender                        | Male                                  |
      | has_special_needs             | Yes                                   |
      | special_needs                 | My special needs are as follows       |
    And I fill in my claimant contact details with:
      | field                         | value                                 |
      | building                      | 102                                   |
      | street                        | Petty France                          |
      | locality                      | London                                |
      | county                        | Greater London                        |
      | post_code                     | SW1H 9AJ                              |
      | country                       | United Kingdom                        |
      | telephone_number              | 01234 567890                          |
      | alternative_telephone_number  | 01234 098765                          |
      | email_address                 | test@digital.justice.gov.uk           |
      | correspondence                | Email                                 |
    And I save the claimant details
    And I answer Yes to the group claims question
    And I fill in the first group claimant details with:
      | field                         | value                                 |
      | title                         | Mrs                                   |
      | first_name                    | GroupFirst                            |
      | last_name                     | GroupLast                             |
      | date_of_birth                 | 25/12/1989                            |
      | building                      | 104                                   |
      | street                        | Oxford Street                         |
      | locality                      | London                                |
      | county                        | Greater London                        |
      | post_code                     | SW1H 9JA                              |
    And I save the group claims
    And I answer Yes to the representative question
    And I fill in the representative's details with:
      | field                         | value                                 |
      | type                          | Solicitor                             |
      | organisation_name             | Solicitors Are Us Fake Company        |
      | name                          | Solicitor Name                        |
    And I fill in the representative's contact details with:
      | field                         | value                                 |
      | building                      | 106                                   |
      | street                        | Mayfair                          |
      | locality                      | London                                |
      | county                        | Greater London                        |
      | post_code                     | SW1H 9PP                              |
      | telephone_number              | 01111 123456                          |
      | alternative_telephone_number  | 02222 654321                          |
      | email_address                 | solicitor.test@digital.justice.gov.uk |
      | dx_number                     | dx1234567890                          |
    And I save the representative's details
    And I fill in the respondent's details with:
      | field                         | value                                 |
      | name                          | Respondent Name                       |
      | building                      | 108                                   |
      | street                        | Regent Street                         |
      | locality                      | London                                |
      | county                        | Greater London                        |
      | post_code                     | SW1H 9QR                              |
      | telephone_number              | 02222 321654                          |
    And I answer No to working at the same address question
    And I fill in my work address with:
      | field                         | value                                 |
      | building                      | 110                                   |
      | street                        | Piccadily Circus                      |
      | locality                      | London                                |
      | county                        | Greater London                        |
      | post_code                     | SW1H 9ST                              |
      | telephone_number              | 03333 423554                          |
    And I fill in my acas certificate number with AC123456/78/90
    And I save the respondent's details
    And I debug


