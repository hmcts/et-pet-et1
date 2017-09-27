Feature: Refund Form
  Background:
    Given I am "Luke Skywalker"
    And I want a refund for my previous ET claim with case number "1234567/2016"

  Scenario: Refund for a sole party who paid directly, used no representative and whos name or address has not changed (sunny path)
    And I have a bank account
    And my name has not changed since the original claim that I want a refund for
    And my address has not changed since the original claim that I want a refund for
    And I did not have a representative
    And I am on the landing page

    When I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I fill in the refund forms
    And I verify the review page and accept the declaration
    Then I should see a valid confirmation page for a claimant
    And I take a screenshot named "Page 7 - Confirmation"

  Scenario: Refund for a sole party who paid directly, used no representative, whos name or address has not changed and only has some fees
    And I have a bank account
    And my name has not changed since the original claim that I want a refund for
    And my address has not changed since the original claim that I want a refund for
    And I did not have a representative
    And I did not have an EAT issue fee
    And I am on the landing page

    When I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I fill in the refund forms
    And I verify the review page and accept the declaration
    Then I should see a valid confirmation page for a claimant
    And I take a screenshot named "Page 7 - Confirmation"

  Scenario: Refund for an individual claimant whos representative paid the fees and the indivual reimbursed them whos name or address has not changed (sunny path)
    And I have a bank account
    And my name has not changed since the original claim that I want a refund for
    And my address has not changed since the original claim that I want a refund for
    And I had a representative
    And I am on the landing page

    When I start a new refund for an individual claimant whos representative paid the fees and the indivual reimbursed them
    And I fill in the refund forms
    And I verify the review page and accept the declaration
    Then I should see a valid confirmation page for a claimant
    And I take a screenshot named "Page 7 - Confirmation"

  Scenario: Refund for an individual claimant who paid a fee to the employment appeal tribunal whos name or address has not changed (sunny path)
    And I have a bank account
    And my name has not changed since the original claim that I want a refund for
    And my address has not changed since the original claim that I want a refund for
    And I did not have a representative
    And I am on the landing page

    When I start a new refund for an individual claimant who paid a fee to the employment appeal tribunal
    And I fill in the refund forms
    And I verify the review page and accept the declaration
    Then I should see a valid confirmation page for a claimant
    And I take a screenshot named "Page 7 - Confirmation"

  Scenario: Refund for a sole party who paid directly, used a representative and whos name or address has not changed
    And I have a bank account
    And my name has not changed since the original claim that I want a refund for
    And my address has not changed since the original claim that I want a refund for
    And I had a representative
    And I am on the landing page

    When I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I fill in the refund forms
    And I verify the review page and accept the declaration
    Then I should see a valid confirmation page for a claimant
    And I take a screenshot named "Page 7 - Confirmation"
    # Dont forget printing

  Scenario: Refund for a sole party who paid directly and whos name has not changed but address has
    And I did not have a representative
    And I have a bank account
    And my name has not changed since the original claim that I want a refund for
    And my address has changed since the original claim that I want a refund for
    And I am on the landing page

    When I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I fill in the refund forms
    And I verify the review page and accept the declaration
    Then I should see a valid confirmation page for a claimant
    And I take a screenshot named "Page 7 - Confirmation"

  Scenario: Refund for a sole party who paid directly and whos name or address has not changed but uses a building society account
    And I did not have a representative
    And I have a building society account
    And my name has not changed since the original claim that I want a refund for
    And my address has not changed since the original claim that I want a refund for
    And I am on the landing page

    When I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I fill in the refund forms
    And I verify the review page and accept the declaration
    Then I should see a valid confirmation page for a claimant

