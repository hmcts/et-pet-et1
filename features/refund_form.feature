Feature: Refund Form

  Scenario: Refund profile 2
    Given I am on the landing page
    And I start a new refund
    And I save my refund with a valid email address and password
    And I select "I was a sole party who paid the Tribunal fees directly and have not been reimbursed by anyone" from the refund type page
    And I save my profile selection on the refund type page
    And I answer No to the has your name changed question for refunds
    And I fill in my refund claimant details with:
      | field              | value      |
      | title              | Mr         |
      | first_name         | First      |
      | last_name          | Last       |
      | date_of_birth      | 21/11/1982 |
      | national_insurance | AB123456D  |
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
    And I answer No to the has your address changed question for refunds
    And I save the refund applicant details
    And I fill in my refund original case details with:
      | field                   | value            |
      | et_reference_number     | ETRef001         |
      | et_case_number          | 1234567/2016     |
      | et_tribunal_office      | NG0001           |
      | extra_reference_numbers | REF1, REF2, REF3 |
    And I fill in my refund original case details respondent details with:
      | field     | value           |
      | name      | Respondent Name |
      | post_code | SW1H 9QR        |
    And I ensure that my refund original case details claimant name is visible but disabled as:
      | field              | value      |
      | title              | Mr         |
      | first_name         | First      |
      | last_name          | Last       |
      | date_of_birth      | 21/11/1982 |
      | national_insurance | AB123456D  |
    And I debug
    And I ensure that my refund original case details claimant address is visible but read only as:
      | field     | value          |
      | building  | 102            |
      | street    | Petty France   |
      | locality  | London         |
      | county    | Greater London |
      | post_code | SW1H 9AJ       |
      | country   | United Kingdom |

    And all background jobs for refund submissions are processed
    And I save a copy of my refund
    Then something should happen
