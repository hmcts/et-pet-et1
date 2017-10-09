Feature: Refund Validations - Confirmation Page
  In order to ensure that the information provided to the business is
  as accurate as possible, field level validation is required to show
  the user where they have gone wrong before they move on to the next step

  Background:
    Given I am "Luke Skywalker"
    And I want a refund for my previous ET claim with case number "1234567/2016"
    And my name has not changed since the original claim that I want a refund for
    And I did not have a representative
    And I have a bank account
    And I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I fill in my refund applicant details
    And I answer No to the has your address changed question for refunds
    And I fill in my refund original case details
    And I fill in my refund fees and verify the total
    And I fill in my refund bank details

  Scenario: A user does not check the accept the declaration in the review page
    Then the continue button should be disabled on the review page
