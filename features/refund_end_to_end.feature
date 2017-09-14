Feature: Refund Form

  Scenario: Refund for a sole party who paid directly (sunny path)
    Given I am "Luke Skywalker"
    And I want a refund for my previous ET claim with case number "1234567/2016"
    And I am on the landing page
    When I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I answer No to the has your name changed question for refunds
    And I fill in my refund applicant details
    And I answer Yes to the address same as applicant question for refunds
    And I fill in my refund original case details
    And I fill in my refund bank details
    And I accept the refund final declaration
    Then I should see a valid refund reference number starting with "C"
    And I take a screenshot named "Page 6 - Confirmation"

