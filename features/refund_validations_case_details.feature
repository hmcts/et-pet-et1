Feature: Refund Validations - Case Details Page
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

  Scenario: A user does not fill in any fields in the case details step
    And I save the refund case details
    Then all mandatory respondent address fields in the refund case details should be marked with an error
    And the country of claim field in the refunds case details should be marked with an error
    And the has your address changed field in the refund case details should be marked with an error
    And the had representative field in the refund case details should be marked with an error
    And I take a screenshot named "Page 3 - Original case details same address with errors"

  Scenario: A user does not fill in any fields in the case details step with same address
    When I answer No to the has your address changed question for refunds
    And I save the refund case details
    Then all mandatory respondent address fields in the refund case details should be marked with an error
    And the had representative field in the refunds case details should be marked with an error
    And the country of claim field in the refunds case details should be marked with an error
    And I take a screenshot named "Page 3 - Original case details same address with errors"

  Scenario: A user does not fill in any fields in the case details step with changed address
    When I answer Yes to the has your address changed question for refunds
    And I save the refund case details
    Then all mandatory claimant address fields in the refund case details should be marked with an error
    And all mandatory respondent address fields in the refund case details should be marked with an error
    And the had representative field in the refunds case details should be marked with an error
    And I take a screenshot named "Page 3 - Original case details different address with errors"

  Scenario: A user does not fill in any fields apart from has representative in the case details step with same address
    When I answer No to the has your address changed question for refunds
    And I answer Yes to the had representative question for refunds
    And I save the refund case details
    Then all mandatory respondent address fields in the refund case details should be marked with an error
    And all mandatory representative address fields in the refund case details should be marked with an error
    And all mandatory case details fields in the refund case details should be marked with an error
    And I take a screenshot named "Page 3 - Original case details same address with errors"

  Scenario: A user fills in wrongly formatted ET and ET case numbers in the case details step with same address and no representative
    When I answer No to the has your address changed question for refunds
    And I answer No to the had representative question for refunds
    And I fill in my refund original case details with:
      | field           | value               |
      | et_case_number  | 12345678/2019       |
      | eat_case_number | UKWRONG/1234/16/001 |
    And I save the refund case details
    Then I should see the following errors in the case details section of the refund case details step:
      | field           | error                                   |
      | et_case_number  | Must be in the format nnnnnnn/nnnn      |
      | eat_case_number | Must be in the format UKEAT/nnnn/nn/nnn |

  Scenario: A user types too many characters into the additional information field in the case details step with same address and no representative
    When I answer No to the has your address changed question for refunds
    And I answer No to the had representative question for refunds
    And I enter 501 characters into the additional information field in the refund case details
    Then I should see 500 characters in the additional information field in the refund case details
