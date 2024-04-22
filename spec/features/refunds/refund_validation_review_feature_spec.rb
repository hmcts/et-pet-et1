require 'rails_helper'

RSpec.describe 'Refund Validations - Confirmation Page', js: true, type: :feature do
  # In order to ensure that the information provided to the business is
  # as accurate as possible, field level validation is required to show
  # the user where they have gone wrong before they move on to the next step

  before do
    given_i_am_luke_skywalker
    and_i_want_a_refund_for_my_previous_et_claim_with_case_number_1234567_2016
    and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_i_did_not_have_a_representative
    and_i_have_a_bank_account
    when_i_start_a_new_refund_for_a_sole_party_who_paid_the_tribunal_fees_directly_and_has_not_been_reimbursed
    and_i_fill_in_my_refund_applicant_details
    when_i_answer_no_to_the_has_your_address_changed_question_for_refunds
    and_i_fill_in_my_refund_original_case_details
    and_i_fill_in_my_refund_fees_and_verify_the_total
    and_i_fill_in_my_refund_bank_details
  end

  it 'A user does not check the accept the declaration in the review page' do
    then_the_continue_button_should_be_disabled_on_the_review_page
  end
end
