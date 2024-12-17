require 'rails_helper'
RSpec.describe 'Refund form with error recovery', :js, type: :feature do
  # Assuming Anakin Skywalker's profile does not have any
  # of the optional field values such as town/city, county, respondent post code etc..
  # and he has a claim with case number 1234567/2015 which has all optional data missing also
  before do
    given_i_am_anakin_skywalker
    and_i_want_a_refund_for_my_previous_et_claim_with_case_number_1234567_2015
  end

  it 'Refund for a sole party who paid directly, used a representative and whos name or address has changed' do
    and_i_have_a_bank_account
    and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_my_address_has_changed_minimal_details_since_the_original_claim_that_i_want_a_refund_for
    and_i_had_a_representative_with_minimal_details

    when_i_start_a_new_refund_for_a_sole_party_who_paid_the_tribunal_fees_directly_and_has_not_been_reimbursed
    and_my_session_dissapears_from_a_timeout
    and_i_fill_in_my_refund_applicant_details
    then_i_should_see_the_profile_selection_page_with_a_session_reloaded_message
  end
end
