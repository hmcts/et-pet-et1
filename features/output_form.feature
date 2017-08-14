Feature: Output Form

  @mock_jadu
  Scenario: Scenario 1
    Given I am on the new claim page
    And I start a new claim
    And I save my claim with a valid email address and password
    And I fill in my claimant details with:
      | field             | value                           |
      | title             | Mr                              |
      | first_name        | First                           |
      | last_name         | Last                            |
      | date_of_birth     | 21/11/1982                      |
      | gender            | Male                            |
      | has_special_needs | Yes                             |
      | special_needs     | My special needs are as follows |
    And I fill in my claimant contact details with:
      | field                        | value                       |
      | building                     | 102                         |
      | street                       | Petty France                |
      | locality                     | London                      |
      | county                       | Greater London              |
      | post_code                    | SW1H 9AJ                    |
      | country                      | United Kingdom              |
      | telephone_number             | 01234 567890                |
      | alternative_telephone_number | 01234 098765                |
      | email_address                | test@digital.justice.gov.uk |
      | correspondence               | Email                       |
    And I save the claimant details
    And I answer Yes to the group claims question
    And I fill in the first group claimant details with:
      | field         | value          |
      | title         | Mrs            |
      | first_name    | GroupFirst     |
      | last_name     | GroupLast      |
      | date_of_birth | 25/12/1989     |
      | building      | 104            |
      | street        | Oxford Street  |
      | locality      | London         |
      | county        | Greater London |
      | post_code     | SW1H 9JA       |
    And I choose to add more claimants
    And I fill in the second group claimant details with:
      | field         | value          |
      | title         | Mrs            |
      | first_name    | Group2First    |
      | last_name     | Group2Last     |
      | date_of_birth | 25/12/1988     |
      | building      | 106            |
      | street        | Regent Street  |
      | locality      | London         |
      | county        | Greater London |
      | post_code     | SW1H 9JB       |
    And I choose to add more claimants
    And I fill in the third group claimant details with:
      | field         | value          |
      | title         | Mrs            |
      | first_name    | Group3First    |
      | last_name     | Group3Last     |
      | date_of_birth | 21/12/1993     |
      | building      | 108            |
      | street        | Pall Mall      |
      | locality      | London         |
      | county        | Greater London |
      | post_code     | SW1H 9JJ       |
    And I choose to add more claimants
    And I fill in the fourth group claimant details with:
      | field         | value          |
      | title         | Mrs            |
      | first_name    | Group4First    |
      | last_name     | Group4Last     |
      | date_of_birth | 21/11/1992     |
      | building      | 110            |
      | street        | Buckingham Pl  |
      | locality      | London         |
      | county        | Greater London |
      | post_code     | SW1H 9JT       |
    And I choose to add more claimants
    And I fill in the fifth group claimant details with:
      | field         | value          |
      | title         | Mrs            |
      | first_name    | Group5First    |
      | last_name     | Group5Last     |
      | date_of_birth | 21/10/1991     |
      | building      | 112            |
      | street        | Oxford Road    |
      | locality      | London         |
      | county        | Greater London |
      | post_code     | SW1H 9JY       |
    And I save the group claims
    And I answer Yes to the representative question
    And I fill in the representative's details with:
      | field             | value                          |
      | type              | Solicitor                      |
      | organisation_name | Solicitors Are Us Fake Company |
      | name              | Solicitor Name                 |
    And I fill in the representative's contact details with:
      | field                        | value                                 |
      | building                     | 106                                   |
      | street                       | Mayfair                               |
      | locality                     | London                                |
      | county                       | Greater London                        |
      | post_code                    | SW1H 9PP                              |
      | telephone_number             | 01111 123456                          |
      | alternative_telephone_number | 02222 654321                          |
      | email_address                | solicitor.test@digital.justice.gov.uk |
      | dx_number                    | dx1234567890                          |
    And I save the representative's details
    And I fill in the respondent's details with:
      | field            | value           |
      | name             | Respondent Name |
      | building         | 108             |
      | street           | Regent Street   |
      | locality         | London          |
      | county           | Greater London  |
      | post_code        | SW1H 9QR        |
      | telephone_number | 02222 321654    |
    And I answer No to working at the same address question
    And I fill in my work address with:
      | field            | value            |
      | building         | 110              |
      | street           | Piccadily Circus |
      | locality         | London           |
      | county           | Greater London   |
      | post_code        | SW1H 9ST         |
      | telephone_number | 03333 423554     |
    And I fill in my acas certificate number with AC123456/78/90
    And I save the respondent's details
    And I answer Yes to the additional respondents question
    And I fill in the second respondent's details with:
      | field       | value          |
      | name        | Respondent Two |
      | building    | 112            |
      | street      | Oxford Street  |
      | locality    | London         |
      | county      | Greater London |
      | post_code   | SW1H 9UV       |
      | acas_number | AC654321/87/09 |
    And I choose to add another respondent
    And I fill in the third respondent's details with:
      | field       | value             |
      | name        | Respondent Three  |
      | building    | 114               |
      | street      | Knightsbridge     |
      | locality    | London            |
      | county      | Greater London    |
      | post_code   | SW1H 9WX          |
      | acas_number | AC654321/88/10    |
    And I choose to add another respondent
    And I fill in the fourth respondent's details with:
      | field       | value             |
      | name        | Respondent Four   |
      | building    | 116               |
      | street      | Mayfair           |
      | locality    | London            |
      | county      | Greater London    |
      | post_code   | SW1H 9YZ          |
      | acas_number | AC654321/88/10    |
    And I choose to add another respondent
    And I fill in the fifth respondent's details with:
      | field       | value             |
      | name        | Respondent Five   |
      | building    | 118               |
      | street      | Marylebone Road   |
      | locality    | London            |
      | county      | Greater London    |
      | post_code   | SW1H 8AB          |
      | acas_number | AC654321/89/11    |
    And I save the additional respondents
    And I answer Yes to the have you ever been employed by the person you are making the claim against question
    And I answer "Still working for this employer" to the current work situation question
    And I fill in the employment details with:
      | field                | value           |
      | job_title            | Project Manager |
      | start_date           | 18/11/2009      |
      | notice_period        | Yes             |
      | notice_period_value  | 3 Months        |
      | average_weekly_hours | 38              |
    And I fill in the pay, pension and benefits with:
      | field                    | value                            |
      | pay_before_tax           | 3000 Monthly                     |
      | pay_after_tax            | 2000 Monthly                     |
      | employers_pension_scheme | Yes                              |
      | benefits                 | Company car, private health care |
    And I save the employment details
    And I answer "Unfair dismissal (including constructive dismissal)" to the about the claim question
    And I answer Yes to the whistleblowing claim question
    And I answer Yes to the send copy to relevant person that deals with whistleblowing question
    And I save the claim type
    And I fill in the claim description with "Full text version of claim"
    And I answer Yes to the similar claims question
    And I fill in the similar claim names with "Similar Claim1, Similar Claim2"
    And I save the claim details
    And I answer "Compensation" to the preferred outcome question
    And I fill in the compensation field with "I would like 50,000 GBP due to the stress this caused me"
    And I save the claim outcome
    And I answer Yes to the other important details question
    And I fill in the important details with "Here are some very important details that need to be considered"
    And I save the more about the claim form
    And I submit my claim
    And all background jobs for claim submissions are processed
    And I save a copy of my claim
    Then the claim pdf file should contain:
      | field                         | value                                                           |
      | 1.1 title tick boxes          | mr                                                              |
      | 1.2 first names               | First                                                           |
      | 1.3 surname                   | Last                                                            |
      | 1.4 DOB day                   | 21                                                              |
      | 1.4 DOB month                 | 11                                                              |
      | 1.4 DOB year                  | 1982                                                            |
      | 1.4 gender                    | male                                                            |
      | 1.5 number                    | 102                                                             |
      | 1.5 street                    | Petty France                                                    |
      | 1.5 town city                 | London                                                          |
      | 1.5 county                    | Greater London                                                  |
      | 1.6 phone number              | 01234 567890                                                    |
      | 1.7 mobile number             | 01234 098765                                                    |
      | 1.8 tick boxes                | email                                                           |
      | 1.9 email                     | test@digital.justice.gov.uk                                     |
      | 1.10 fax number               |                                                                 |
      | 1.5 postcode                  | SW1H9AJ                                                         |
      | 2.2 postcode                  | SW1H9QR                                                         |
      | 2.1                           | Respondent Name                                                 |
      | 2.2 number                    | 108                                                             |
      | 2.2 street                    | Regent Street                                                   |
      | 2.2 town city                 | London                                                          |
      | 2.2 county                    | Greater London                                                  |
      | 2.2 phone number              | 02222 321654                                                    |
      | 2.3 postcode                  | SW1H9ST                                                         |
      | 2.3 number                    | 110                                                             |
      | 2.3 street                    | Piccadily Circus                                                |
      | 2.3 town city                 | London                                                          |
      | 2.3 county                    | Greater London                                                  |
      | 2.3 phone number              | 03333 423554                                                    |
      | 2.4 tick box                  | yes                                                             |
      | 2.4 R2 postcode               | SW1H9UV                                                         |
      | 2.4 R2 name                   | Respondent Two                                                  |
      | 2.4 R2 number                 | 112                                                             |
      | 2.4 R2 street                 | Oxford Street                                                   |
      | 2.4 R2 town                   | London                                                          |
      | 2.4 R2 county                 | Greater London                                                  |
      | 2.4 R2 phone number           |                                                                 |
      | 2.4 R3 postcode               | SW1H9WX                                                         |
      | 2.4 R3 name                   | Respondent Three                                                |
      | 2.4 R3 number                 | 114                                                             |
      | 2.4 R3 street                 | Knightsbridge                                                   |
      | 2.4 R3 town city              | London                                                          |
      | 2.4 R3 county                 | Greater London                                                  |
      | 2.4 R3 phone number           |                                                                 |
      | 3.1 tick boxes                | yes                                                             |
      | 3.1 if yes                    | Similar Claim1, Similar Claim2                                  |
      | 4.1                           |                                                                 |
      | 5.1 employment start          | 18/11/2009                                                      |
      | 5.1 tick boxes                | yes                                                             |
      | 5.1 employment end            |                                                                 |
      | 5.1 not ended                 |                                                                 |
      | 5.2                           | Project Manager                                                 |
      | 6.1                           | 38.0                                                            |
      | 6.2 pay before tax            | 3000                                                            |
      | 6.2 pay before tax tick boxes | monthly                                                         |
      | 6.2 normal pay                | 2000                                                            |
      | 6.2 normal pay tick boxes     | monthly                                                         |
      | 6.3 tick boxes                | Off                                                             |
      | 6.3 weeks                     |                                                                 |
      | 6.3 months                    |                                                                 |
      | 6.4 tick boxes                | yes                                                             |
      | 6.5                           | Company car, private health care                                |
      | 7.1 tick boxes                | Off                                                             |
      | 7.2                           |                                                                 |
      | 7.3                           |                                                                 |
      | 8.1 unfairly tick box         | yes                                                             |
      | 8.1 discriminated             | Off                                                             |
      | 8.1 age                       | Off                                                             |
      | 8.1 race                      | Off                                                             |
      | 8.1 gender reassignment       | Off                                                             |
      | 8.1 disability                | Off                                                             |
      | 8.1 pregnancy                 | Off                                                             |
      | 8.1 marriage                  | Off                                                             |
      | 8.1 sexual orientation        | Off                                                             |
      | 8.1 sex                       | Off                                                             |
      | 8.1 religion                  | Off                                                             |
      | 8.1 redundancy                | Off                                                             |
      | 8.1 owed                      | Off                                                             |
      | 8.1 notice pay                | Off                                                             |
      | 8.1 holiday pay               | Off                                                             |
      | 8.1 arrears of pay            | Off                                                             |
      | 8.1 other payments            | Off                                                             |
      | 8.1 another type of claim     | Off                                                             |
      | 8.1 other type of claim       |                                                                 |
      | 8.2                           | Full text version of claim                                      |
      | 9.1 old job back              | Off                                                             |
      | 9.1 another job               | Off                                                             |
      | 9.1 compensation              | yes                                                             |
      | 9.1 recommendation            | Off                                                             |
      | 9.2                           | I would like 50,000 GBP due to the stress this caused me        |
      | 10.1                          | yes                                                             |
      | 11.3 postcode                 | SW1H9PP                                                         |
      | 11.1                          | Solicitor Name                                                  |
      | 11.2                          | Solicitors Are Us Fake Company                                  |
      | 11.3 number                   | 106                                                             |
      | 11.3 street                   | Mayfair                                                         |
      | 11.3 town city                | London                                                          |
      | 11.3 county                   | Greater London                                                  |
      | 11.4 dx number                | dx1234567890                                                    |
      | 11.5 phone number             | 01111 123456                                                    |
      | 11.6 mobile number            | 02222 654321                                                    |
      | 11.7 reference                |                                                                 |
      | 11.8 email                    | solicitor.test@digital.justice.gov.uk                           |
      | 11.9 tick boxes               | Off                                                             |
      | 11.10 fax number              |                                                                 |
      | 12.1 tick box                 | yes                                                             |
      | 12.1 if yes                   | My special needs are as follows                                 |
      | 13 R4 name                    | Respondent Four                                                 |
      | 13 R4 number                  | 116                                                             |
      | 13 R4 street                  | Mayfair                                                         |
      | 13 R4 town city               | London                                                          |
      | 13 R4 county                  | Greater London                                                  |
      | 13 R4 postcode                | SW1H9YZ                                                         |
      | 13 R4 phone number            |                                                                 |
      | 13 R5 name                    | Respondent Five                                                 |
      | 13 R5 number                  | 118                                                             |
      | R5 street                     | Marylebone Road                                                 |
      | R5 town city                  | London                                                          |
      | R5 county                     | Greater London                                                  |
      | R5 postcode                   | SW1H8AB                                                         |
      | R5 phone number               |                                                                 |
      | 14 satisfied tick box         |                                                                 |
      | 15                            | Here are some very important details that need to be considered |
      | claim type a                  |                                                                 |
      | claim type b                  |                                                                 |
      | claim type c                  |                                                                 |
      | claim type d                  |                                                                 |
      | claim type e                  |                                                                 |
      | Check Box1                    | Yes                                                             |
      | Text2                         | AC123456/78/90                                                  |
      | Check Box8                    | Yes                                                             |
      | Text9                         | AC654321/87/09                                                  |
      | Check Box15                   | Yes                                                             |
      | Text16                        | AC654321/88/10                                                  |
      | Check Box22                   | Yes                                                             |
      | Text23                        | AC654321/88/10                                                  |
      | Check Box29                   | Yes                                                             |
      | Text30                        | AC654321/89/11                                                                |


