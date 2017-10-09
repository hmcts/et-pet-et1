Feature: Refund form with error recovery
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

    When I start a new refund for a sole party who paid the tribunal fees directly and has not been reimbursed
    And my session dissapears from a timeout
    And I fill in my refund applicant details
    Then I should see the profile selection page with a session reloaded message
    And I take a screenshot named "Page 1 - Profile selection after session timeout"
