Feature: Refund Validations - Payment Page
  In order to ensure that the information provided to the business is
  as accurate as possible, field level validation is required to show
  the user where they have gone wrong before they move on to the next step

  Background:
    Given I am "Luke Skywalker"
    And I want a refund for my previous ET claim with case number "1234567/2016"
    And my name has not changed since the original claim that I want a refund for
    And I did not have a representative
    And I am on the landing page
    And I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I fill in my refund applicant details
    And I answer No to the has your address changed question for refunds
    And I fill in my refund original case details
    And I fill in my refund fees and verify the total

  Scenario: A user does not fill in any fields in the bank details page
    Then the continue button should be disabled on the bank details page

  Scenario: A user does not fill in any fields apart from selecting the bank account type
    When I select "Bank" account type in the refund bank details page
    And I save the refund bank details
    Then all mandatory bank details fields should be marked with an error
    And I take a screenshot named "Page 5 - Bank details with errors"

  Scenario: A user does not fill in any fields apart from selecting the building society type
    When I select "Building Society" account type in the refund bank details page
    And I save the refund bank details
    Then all mandatory building society details fields should be marked with an error
    And I take a screenshot named "Page 5 - Building society details with errors"

  Scenario: A user fills in the bank details then changes to a building society but does not fill in any more fields
    When I select "Bank" account type in the refund bank details page
    And I fill in my refund bank details with:
      | field          | value          |
      | account_name   | Luke Skywalker |
      | bank_name      | Bank Name      |
      | account_number | 12345678       |
      | sort_code      | 123456         |
    And I select "Building Society" account type in the refund bank details page
    And I save the refund bank details
    Then all mandatory building society details fields should be marked with an error

  Scenario: A user fills in invalid bank account number and sort code in the refund bank details page
    When I select "Bank" account type in the refund bank details page
    And I fill in my refund bank details with:
      | field          | value          |
      | account_name   | Luke Skywalker |
      | bank_name      | Bank Name      |
      | account_number | 123456789      |
      | sort_code      | 1234567        |
    And I save the refund bank details
    Then the bank account number field should be marked with an invalid error in the refund bank details page
    Then the bank sort code field should be marked with an invalid error in the refund bank details page

  Scenario: A user fills in invalid building society account number and sort code in the refund bank details page
    When I select "Building Society" account type in the refund bank details page
    And I fill in my refund building society details with:
      | field                 | value          |
      | account_name          | Luke Skywalker |
      | building_society_name | Bank Name      |
      | account_number        | 123456789      |
      | sort_code             | 1234567        |
    And I save the refund bank details
    Then the building society account number field should be marked with an invalid error in the refund bank details page
    Then the building society sort code field should be marked with an invalid error in the refund bank details page

