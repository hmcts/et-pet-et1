Feature: Refund form with no optional fields filled in
  Background:
    Given I am "Anakin Skywalker"
    # No town/city, county, email address in applicant page
    # No town/city, county for your address at time of claim in case details page
    # No town/city, county for rep address in case details page
    # No town/city, county or post code for respondent address in case details page
    # No employment tribunal office, et case no, eat case no or additional info in case details
    # No fees at all in fees page



    And I want a refund for my previous ET claim with case number "1234567/2015"

  Scenario: Refund for a sole party who paid directly, used a representative and whos name or address has changed
    And I have a bank account
    And my name has not changed since the original claim that I want a refund for
    And my address has changed (minimal details) since the original claim that I want a refund for
    And I had a representative with minimal details
    And I am on the landing page

    When I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And I fill in the refund forms
    And I verify the review page and accept the declaration
    Then I should see a valid confirmation page for a claimant
    And I take a screenshot named "Page 7 - Confirmation"
