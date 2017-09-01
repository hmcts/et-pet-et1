Feature: Refund Form

  Scenario: Refund profile 2
    Given I am on the landing page
    And I start a new refund
    And I take a screenshot
    And I save my refund with a valid email address and password
    And I take a screenshot
    And I select "Profile 2 label" from the refund type page
    And I take a screenshot
    And I save my profile selection on the refund type page
    And I take a screenshot
    And I answer Yes to the are you the claimant question for refunds
    And I take a screenshot
    And I answer No to the has your name changed question for refunds
    And I take a screenshot
    And I fill in my refund claimant details with:
      | field             | value                           |
      | title             | Mr                              |
      | first_name        | First                           |
      | last_name         | Last                            |
      | date_of_birth     | 21/11/1982                      |
      | national_insurance| AB123456D                       |
    And I take a screenshot
    And I fill in my refund claimant contact details with:
      | field                        | value                       |
      | building                     | 102                         |
      | street                       | Petty France                |
      | locality                     | London                      |
      | county                       | Greater London              |
      | post_code                    | SW1H 9AJ                    |
      | country                      | United Kingdom              |
      | telephone_number             | 01234 567890                |
      | alternative_telephone_number | 01234 098765                |
      | email_address                | test@digital.justice.gov.uk |
    And I take a screenshot
    And I answer No to the has your address changed question for refunds
    And I take a screenshot
    And I save the refund claimant details
    And I take a screenshot
    And I debug
    And all background jobs for refund submissions are processed
    And I save a copy of my refund
    Then something should happen
