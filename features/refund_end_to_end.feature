Feature: Refund Form

  Scenario: Refund profile 2
    Given I am "Luke Skywalker"
    And I am on the landing page
    When I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I answer No to the has your name changed question for refunds
    And I fill in my refund applicant details
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
    And I take a screenshot named "Page 3 - Original Case Details"
    And I save the refund case details
    And I fill in my refund bank details with:
      | field          | value         |
      | account_name   | Mr First Last |
      | bank_name      | Fake Bank     |
      | account_number | 12345678      |
      | sort_code      | 010203        |
    And I take a screenshot named "Page 4 - Bank Account Details"
    And I save the refund bank details
    And I accept the refund final declaration
    And I take a screenshot named "Page 5 - Review"
    And I save the final refund
    Then I should see a valid refund reference number starting with "C"
    And I take a screenshot named "Page 6 - Confirmation"

