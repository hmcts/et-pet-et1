Feature: Refund Form

  Scenario: Refund for a sole party who paid directly (sunny path)
    Given I am "Luke Skywalker"
    And I want a refund for my previous ET claim with case number "1234567/2016"
    And I have a bank account
    And my name has not changed since the original claim that I want a refund for
    And my address has not changed since the original claim that I want a refund for
    And I am on the landing page

    When I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I fill in the refund forms and accept the declaration
    Then I should see a valid refund reference number starting with "C"
    And I take a screenshot named "Page 6 - Confirmation"

