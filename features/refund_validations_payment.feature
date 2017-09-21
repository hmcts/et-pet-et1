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

  Scenario: A user does not fill in any fields in the bank details page
    When I fill in my refund applicant details
    And I answer No to the has your address changed question for refunds
    And I fill in my refund original case details
    And I save the refund bank details
    Then only the bank details account type field should be marked with an error

  Scenario: A user does not fill in any fields apart from selecting the bank account type
    When I fill in my refund applicant details
    And I answer No to the has your address changed question for refunds
    And I fill in my refund original case details
    And I select "Bank" account type in the refund bank details page
    And I save the refund bank details
    Then all mandatory bank details fields should be marked with an error

  Scenario: A user does not fill in any fields apart from selecting the building society type
    When I fill in my refund applicant details
    And I answer No to the has your address changed question for refunds
    And I fill in my refund original case details
    And I select "Building Society" account type in the refund bank details page
    And I save the refund bank details
    Then all mandatory building society details fields should be marked with an error
