Feature: Refund Validations - Profile selection page
  In order to ensure that the user is
  of a particular profile, profile selection with validation is required to make
  sure the user has selected a valid profile before they move on to the next step
  Background:
    Given I start a new refund

  Scenario: A user does not fill in any fields in the applicant step
    When I save my profile selection on the refund type page
    Then the continue button should be disabled on the profile selection page
    And I take a screenshot named "Page 1 - Profile selection with errors"

