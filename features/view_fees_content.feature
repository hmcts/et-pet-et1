Feature: Refund - Fees Page Content
  In order to assist the user in providing accurate information
  the content of the page should provide assistance and useful content

  Background:
    Given I am "Luke Skywalker"
    And I want a refund for my previous ET claim with case number "1234567/2016"
    And my name has not changed since the original claim that I want a refund for
    And my address has not changed since the original claim that I want a refund for
    And I did not have a representative
    And I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I fill in my refund applicant details
    And I fill in my refund original case details

  Scenario: A user fills in fees but no payment method or date
    Then all fee help content should be correct on the fees page
