Feature: Refund Validations
  In order to ensure that the information provided to the business is
  as accurate as possible, field level validation is required to show
  the user where they have gone wrong before they move on to the next step
  Background:
    Given I am "Luke Skywalker"
    And I am on the landing page
    And I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I want a refund for my previous ET claim with case number "1234567/2016"

  Scenario: A user does not fill in any fields in the applicant step
    When I save the refund applicant details
    Then the user should be informed that there are errors on the refund applicant page
    And all mandatory fields in the refund applicant page should be marked with an error
    And I take a screenshot named "Page 2 - Applicant with errors"
  Scenario: A user does not fill in any fields in the case details step with same address
    When I fill in my refund applicant details
    And I answer No to the has your address changed question for refunds
    And I save the refund case details
    Then all mandatory respondent address fields in the refund case details should be marked with an error
    And all mandatory representative address fields in the refund case details should be marked with an error
    And I take a screenshot named "Page 3 - Original case details same address with errors"

  Scenario: A user does not fill in any fields in the case details step with changed address
    When I fill in my refund applicant details
    And I answer Yes to the has your address changed question for refunds
    And I save the refund case details
    Then all mandatory claimant address fields in the refund case details should be marked with an error
    And all mandatory respondent address fields in the refund case details should be marked with an error
    And all mandatory representative address fields in the refund case details should be marked with an error
    And I take a screenshot named "Page 3 - Original case details different address with errors"

  Scenario: A user does not fill in any fields in the bank details page
    When I fill in my refund applicant details
    And I answer No to the has your address changed question for refunds
    And I fill in my refund original case details
    And I save the refund bank details
    Then all mandatory bank details fields should be marked with an error
