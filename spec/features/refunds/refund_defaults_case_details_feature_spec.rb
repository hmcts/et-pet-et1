require 'rails_helper'
RSpec.describe 'Refund Defaults - Case Details Page', :js, type: :feature do
  # In order to provide assistance to the user
  # Some areas of the form have default values

  before do
    given_i_am_luke_skywalker
    and_i_want_a_refund_for_my_previous_et_claim_with_case_number_1234567_2016
    and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_i_did_not_have_a_representative
    when_i_start_a_new_refund_for_a_sole_party_who_paid_the_tribunal_fees_directly_and_has_not_been_reimbursed
    and_i_fill_in_my_refund_applicant_details
  end

  it 'A user does not fill in anything in the case details step with same address and no representative' do

    when_i_answer_no_to_the_has_your_address_changed_question_for_refunds
    and_i_answer_no_to_the_had_representative_question_for_refunds
    then_the_where_was_your_claim_issued_field_in_the_applicant_page_should_have_the_correct_default_option_selected
    and_the_employment_tribunal_office_field_in_the_applicant_page_should_have_the_correct_default_option_selected
  end
end
