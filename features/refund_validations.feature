Feature: Refund Validations
  In order to ensure that the information provided to the business is
  as accurate as possible, field level validation is required to show
  the user where they have gone wrong before they move on to the next step
  Scenario: A user does not fill in any fields in the applicant step
    Given I am on the landing page
    And I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    When I save the refund applicant details
    Then the user should be informed that there are errors on the refund applicant page
    And all mandatory fields in the refund applicant page should be marked with an error
    And I take a screenshot named "Page 1 - Applicant with errors"
