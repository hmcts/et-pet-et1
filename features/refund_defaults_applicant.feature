Feature: Refund Defaults - Applicant page
  In order to provide assistance to the user
  Some areas of the form have default values
  Background:
    Given I am "Luke Skywalker"
    And I want a refund for my previous ET claim with case number "1234567/2016"
    And my name has not changed since the original claim that I want a refund for
    And I did not have a representative
    And I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed

  Scenario: A user does not fill in any fields in the applicant step after answering the name change question as no
    When I answer No to the has your name changed question for refunds
    Then the title field in the applicant page should have the correct default option selected
