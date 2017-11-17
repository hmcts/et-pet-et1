Feature: Output Form

  @mock_jadu
  Scenario: Full claim with many claimants and respondents
    Given I am "Luke Skywalker"
    And I want to apply for an employee tribunal
    And I have special needs for an employee tribunal
    And I want 4 group claimaints for an employee tribunal
    And I want a representative for an employee tribunal
    And I worked as a project manager for the respondent for an employee tribunal
    And I worked at a different address to the respondent address for an employee tribunal
    And I want to claim for unfair dismissal in my employee tribunal
    And I want to blow the whistle on someone in my employee tribunal
    And I want to send the whistleblowing claim to the relevant person in my employee tribunal
    And I want 4 additional respondents for an employee tribunal
    And I know about 2 similar claims for my employment tribunal
    And I want 50,000 pounds compensation from my employee tribunal
    And I am on the new claim page
    When I start a new claim
    And I save my claim with a valid email address and password
    And I fill in my claimant details
    And I fill in my claimant contact details
    And I save the claimant details
    And I fill in my group claimant details
    And I save the group claims
    And I fill in the representative's details
    And I save the representative's details
    And I fill in the respondent's details
    And I fill in my acas certificate number with AC654321/87/01
    And I save the respondent's details
    And I fill in my additional respondents for an employee tribunal
    And I save the additional respondents
    And I answer Yes to the have you ever been employed by the person you are making the claim against question
    And I fill in my employment details for an employee tribunal
    And I save the employment details
    And I fill in my claim type details for my employment tribunal
    And I fill in my whistleblowing details for my employment tribunal
    And I save the claim type
    And I fill in my claim details for my employment tribunal
    And I save the claim details
    And I fill in my preferred outcomes for my employee tribunal
    And I save the claim outcome
    And I answer Yes to the other important details question
    And I fill in the important details with "Here are some very important details that need to be considered"
    And I save the more about the claim form
    And I take a screenshot
    And I submit my claim
    And all background jobs for claim submissions are processed
    And I save a copy of my claim
    Then the claim pdf file's Your details section should contain my details
    And the employment tribunal claim pdf file's Respondent's details should match the first 3 of mine
    And the claim pdf file's Multiple cases section should be correct for my employment tribunal
    # Check this out - I think it is always blank - but should it come from a field somewhere ?
    And the claim pdf file's Respondent not your employer section should contain:
      | field      | value |
      | claim_type |       |

    And the employment tribunal claim pdf file's Respondent Employment details section should match mine
    And the employment tribunal claim pdf file's Respondent Earnings and benefits section should match my employment details
    And the claim pdf file's What happened since section should contain:
      | field            | value |
      | have_another_job | No    |
      | start_date       |       |
      | salary           |       |
    And my employment tribunal claim pdf file's Type and details of claim section should be correct
    And the claim pdf file's What do you want section should contain:
      | field                 | value                                                    |
      | prefer_re_instatement | No                                                       |
      | prefer_re_engagement  | No                                                       |
      | prefer_compensation   | Yes                                                      |
      | prefer_recommendation | No                                                       |
      | compensation          | I would like 50,000 GBP due to the stress this caused me |
    And the claim pdf file's Information to regulators section should contain:
      | field           | value |
      | whistle_blowing | Yes   |
    And the claim pdf file's Your representative section should contain:
      | field                        | value                                 |
      | name_of_organisation         | Solicitors Are Us Fake Company        |
      | name_of_representative       | Solicitor Name                        |
      | building                     | 106                                   |
      | street                       | Mayfair                               |
      | locality                     | London                                |
      | county                       | Greater London                        |
      | post_code                    | SW1H9PP                               |
      | dx_number                    | dx1234567890                          |
      | telephone_number             | 01111 123456                          |
      | alternative_telephone_number | 02222 654321                          |
      | reference                    |                                       |
      | email_address                | solicitor.test@digital.justice.gov.uk |
      | communication_preference     |                                       |
      | fax_number                   |                                       |
    And the claim pdf file's Disability section should contain:
      | field             | value                           |
      | has_special_needs | Yes                             |
      | special_needs     | My special needs are as follows |
    And the claim pdf file's Additional respondents section should contain the following for respondent 4:
      | field            | value               |
      | name             | Respondent4 Surname |
      | building         | 4                   |
      | street           | Oxford Street       |
      | locality         | London              |
      | county           | Greater London      |
      | post_code        | SW1H4UV             |
      | telephone_number |                     |
      | have_acas        | Yes                 |
      | acas_number      | AC654321/87/04      |
    And the claim pdf file's Additional respondents section should contain the following for respondent 5:
      | field            | value               |
      | name             | Respondent5 Surname |
      | building         | 5                   |
      | street           | Oxford Street       |
      | locality         | London              |
      | county           | Greater London      |
      | post_code        | SW1H5UV             |
      | telephone_number |                     |
      | have_acas        | Yes                 |
      | acas_number      | AC654321/87/05      |
    And the claim pdf file's Final check section should contain:
      | field     | value |
      | satisfied | No    |
    And the claim pdf file's Additional information section should contain:
      | field                  | value                                                           |
      | additional_information | Here are some very important details that need to be considered |
