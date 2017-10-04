Feature: Refund Defaults - Case Details Page
  In order to provide assistance to the user
  Some areas of the form have default values

  Background:
    Given I am "Luke Skywalker"
    And I want a refund for my previous ET claim with case number "1234567/2016"
    And my name has not changed since the original claim that I want a refund for
    And I did not have a representative
    And I am on the landing page
    And I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I fill in my refund applicant details

  Scenario: A user does not fill in anything in the case details step with same address and no representative
    When I answer No to the has your address changed question for refunds
    And I answer No to the had representative question for refunds
    Then the where was your claim issued field in the applicant page should have the correct default option selected
    And the employment tribunal office field in the applicant page should have the correct default option selected
