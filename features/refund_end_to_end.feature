Feature: Refund Form

  Scenario: Refund profile 2
    Given I am on the landing page
    And I start a new refund
    When I select "I was a sole party who paid the Tribunal fees directly and have not been reimbursed by anyone" from the refund type page
    And I save my profile selection on the refund type page
    And I answer No to the has your name changed question for refunds
    And I fill in my refund claimant details with:
      | field         | value      |
      | title         | Mr         |
      | first_name    | First      |
      | last_name     | Last       |
      | date_of_birth | 21/11/1982 |
    And I fill in my refund claimant contact details with:
      | field            | value                       |
      | building         | 102                         |
      | street           | Petty France                |
      | locality         | London                      |
      | county           | Greater London              |
      | post_code        | SW1H 9AJ                    |
      | country          | United Kingdom              |
      | telephone_number | 01234 567890                |
      | email_address    | test@digital.justice.gov.uk |
    And I save the refund applicant details
    And I answer Yes to the address same as applicant question for refunds
    And I fill in my refund original case details with:
      | field                  | value            |
      | et_case_number         | 1234567/2016     |
      | et_tribunal_office     | NG0001           |
      | additional_information | REF1, REF2, REF3 |
    And I fill in my refund original case details respondent details with:
      | field     | value           |
      | name      | Respondent Name |
      | post_code | SW1H 9QR        |
    And I fill in my refund original case details representative details with:
      | field     | value               |
      | name      | Representative Name |
      | post_code | SW2H 9ST            |
    And I fill in my refund issue fee with:
      | fee     | payment method |
      | 1000.00 | Card           |
    And I fill in my refund hearing fee with:
      | fee     | payment method |
      | 1001.00 | Cash           |
    And I fill in my refund eat issue fee with:
      | fee     | payment method |
      | 1002.00 | Cheque         |
    And I fill in my refund eat hearing fee with:
      | fee     | payment method |
      | 1003.00 | Card           |
    And I fill in my refund application reconsideration fee with:
      | fee     | payment method |
      | 1004.00 | Card           |
    And I save the refund case details
    And I fill in my refund bank details with:
      | field          | value         |
      | account_name   | Mr First Last |
      | bank_name      | Fake Bank     |
      | account_number | 12345678      |
      | sort_code      | 010203        |
    And I save the refund bank details
    And I accept the refund final declaration
    And I save the final refund
    And I debug

    And all background jobs for refund submissions are processed
    And I save a copy of my refund
    Then something should happen
