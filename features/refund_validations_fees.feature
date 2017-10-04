Feature: Refund Validations - Fees Page
  In order to ensure that the information provided to the business is
  as accurate as possible, field level validation is required to show
  the user where they have gone wrong before they move on to the next step

  Background:
    Given I am "Luke Skywalker"
    And I want a refund for my previous ET claim with case number "1234567/2016"
    And my name has not changed since the original claim that I want a refund for
    And my address has not changed since the original claim that I want a refund for
    And I did not have a representative
    And I am on the landing page
    And I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I fill in my refund applicant details
    And I fill in my refund original case details

  Scenario: A user fills in fees but no payment method or date
    And I fill in all my refund fee values only
    And I save the refund fees
    Then all fee payment method fields in the fees page should be marked with an error
    Then all fee payment date fields in the fees page should be marked with an error

  Scenario: A user fills in no fees data at all and submits
    And I save the refund fees
    Then I should see the refund bank details page

  Scenario: A user fills in no fees data at all and does not submit
    Then all fee payment date fields in the fees page should be disabled
    And all fee payment method fields in the fees page should be disabled

  Scenario: A user fills in fees but no payment method and an unknown date
    And I fill in all my refund fee values only
    And I check all my refund fee unknown dates
    And I save the refund fees
    And all fee payment method fields in the fees page should be marked with an error
    Then all fee payment date fields in the fees page should not be marked with an error

  Scenario: A user fills in fees but the "Don't know" payment method and an unknown date
    And I fill in all my refund fee values only
    And I check all my refund fee unknown dates
    And I fill in all my refund fee payment methods with "Don't know"
    And I save the refund fees
    Then I should see the refund bank details page
