require 'rails_helper'
RSpec.describe 'Refund Form', js: true do
  before do
    given_i_am_luke_skywalker
    and_i_want_a_refund_for_my_previous_et_claim_with_case_number_1234567_2016
  end

  it 'Refund for a sole party who paid directly, used no representative and whos name or address has not changed (sunny path)' do
    and_i_have_a_bank_account
    and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_my_address_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_i_did_not_have_a_representative
    when_i_start_a_new_refund_for_a_sole_party_who_paid_the_tribunal_fees_directly_and_has_not_been_reimbursed
    and_i_fill_in_the_refund_forms
    and_i_verify_the_review_page_and_accept_the_declaration
    then_i_should_see_a_valid_confirmation_page_for_a_claimant
  end

  it 'Refund for a sole party who paid directly, used no representative, whos name or address has not changed and only has some fees' do
    and_i_have_a_bank_account
    and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_my_address_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_i_did_not_have_a_representative
    and_i_did_not_have_an_eat_issue_fee

    when_i_start_a_new_refund_for_a_sole_party_who_paid_the_tribunal_fees_directly_and_has_not_been_reimbursed
    and_i_fill_in_the_refund_forms
    and_i_verify_the_review_page_and_accept_the_declaration
    then_i_should_see_a_valid_confirmation_page_for_a_claimant
  end

  it 'Refund for an individual claimant whos representative paid the fees and the indivual reimbursed them whos name or address has not changed (sunny path)' do
    and_i_have_a_bank_account
    and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_my_address_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_i_had_a_representative

    when_i_start_a_new_refund_for_an_individual_claimant_whos_representative_paid_the_fees_and_the_indivual_reimbursed_them
    and_i_fill_in_the_refund_forms
    and_i_verify_the_review_page_and_accept_the_declaration
    then_i_should_see_a_valid_confirmation_page_for_a_claimant
  end

  it 'Refund for a sole party who paid directly, used a representative and whos name or address has not changed' do
    and_i_have_a_bank_account
    and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_my_address_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_i_had_a_representative

    when_i_start_a_new_refund_for_a_sole_party_who_paid_the_tribunal_fees_directly_and_has_not_been_reimbursed
    and_i_fill_in_the_refund_forms
    and_i_verify_the_review_page_and_accept_the_declaration
    then_i_should_see_a_valid_confirmation_page_for_a_claimant
    # Dont forget printing
  end

  it 'Refund for a sole party who paid directly and whos name has not changed but address has' do
    and_i_did_not_have_a_representative
    and_i_have_a_bank_account
    and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_my_address_has_changed_since_the_original_claim_that_i_want_a_refund_for

    when_i_start_a_new_refund_for_a_sole_party_who_paid_the_tribunal_fees_directly_and_has_not_been_reimbursed
    and_i_fill_in_the_refund_forms
    and_i_verify_the_review_page_and_accept_the_declaration
    then_i_should_see_a_valid_confirmation_page_for_a_claimant
  end

  it 'Refund for a sole party who paid directly and whos name or address has not changed but uses a building society account' do
    and_i_did_not_have_a_representative
    and_i_have_a_building_society_account
    and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_my_address_has_not_changed_since_the_original_claim_that_i_want_a_refund_for

    when_i_start_a_new_refund_for_a_sole_party_who_paid_the_tribunal_fees_directly_and_has_not_been_reimbursed
    and_i_fill_in_the_refund_forms
    and_i_verify_the_review_page_and_accept_the_declaration
    then_i_should_see_a_valid_confirmation_page_for_a_claimant
  end
end
