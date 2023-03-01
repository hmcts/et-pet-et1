require 'rails_helper'
RSpec.describe 'Refund - Fees Page Content', js: true do
  # In order to assist the user in providing accurate information
  # the content of the page should provide assistance and useful content

  before do
    given_i_am_luke_skywalker
    and_i_want_a_refund_for_my_previous_et_claim_with_case_number_1234567_2016
    and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_my_address_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_i_did_not_have_a_representative
    when_i_start_a_new_refund_for_a_sole_party_who_paid_the_tribunal_fees_directly_and_has_not_been_reimbursed
    and_i_fill_in_my_refund_applicant_details
    and_i_fill_in_my_refund_original_case_details
  end

  it 'A user fills in fees but no payment method or date' do
    then_all_fee_help_content_should_be_correct_on_the_fees_page
  end
end
