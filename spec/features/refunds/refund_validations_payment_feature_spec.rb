require 'rails_helper'
RSpec.describe 'Refund Validations - Payment Page', js: true do
  # In order to ensure that the information provided to the business is
  # as accurate as possible, field level validation is required to show
  # the user where they have gone wrong before they move on to the next step

  before do
    given_i_am_luke_skywalker
    and_i_want_a_refund_for_my_previous_et_claim_with_case_number_1234567_2016
    and_my_name_has_not_changed_since_the_original_claim_that_i_want_a_refund_for
    and_i_did_not_have_a_representative
    when_i_start_a_new_refund_for_a_sole_party_who_paid_the_tribunal_fees_directly_and_has_not_been_reimbursed
    and_i_fill_in_my_refund_applicant_details
    when_i_answer_no_to_the_has_your_address_changed_question_for_refunds
    and_i_fill_in_my_refund_original_case_details
    and_i_fill_in_my_refund_fees_and_verify_the_total
  end

  it 'A user does not fill in any fields in the bank details page' do
    then_the_continue_button_should_be_disabled_on_the_bank_details_page
  end

  it 'A user does not fill in any fields apart from selecting the bank account type' do
    and_i_select_bank_account_type_in_the_refund_bank_details_page
    and_i_save_the_refund_bank_details
    then_all_mandatory_bank_details_fields_should_be_marked_with_an_error
  end

  it 'A user does not fill in any fields apart from selecting the building society type' do
    and_i_select_building_society_account_type_in_the_refund_bank_details_page
    and_i_save_the_refund_bank_details
    then_all_mandatory_building_society_details_fields_should_be_marked_with_an_error
  end

  it 'A user fills in the bank details then changes to a building society but does not fill in any more fields' do
    and_i_select_bank_account_type_in_the_refund_bank_details_page
    and_i_fill_in_my_refund_bank_details_with \
      [
        { field: 'account_name', value: 'Luke Skywalker' },
        { field: 'bank_name', value: 'Bank Name' },
        { field: 'account_number', value: '12345678' },
        { field: 'sort_code', value: '123456' }
      ]
    and_i_select_building_society_account_type_in_the_refund_bank_details_page
    and_i_save_the_refund_bank_details
    then_all_mandatory_building_society_details_fields_should_be_marked_with_an_error
  end

  it 'A user fills in invalid bank account number and sort code in the refund bank details page' do
    and_i_select_bank_account_type_in_the_refund_bank_details_page
    and_i_fill_in_my_refund_bank_details_with \
      [
        { field: 'account_name', value: 'Luke Skywalker' },
        { field: 'bank_name', value: 'Bank Name' },
        { field: 'account_number', value: '123456789' },
        { field: 'sort_code', value: '1234567' }
      ]
    and_i_save_the_refund_bank_details
    then_the_bank_account_number_field_should_be_marked_with_an_invalid_error_in_the_refund_bank_details_page
    then_the_bank_sort_code_field_should_be_marked_with_an_invalid_error_in_the_refund_bank_details_page
  end

  it 'A user fills in invalid building society account number and sort code in the refund bank details page' do
    and_i_select_building_society_account_type_in_the_refund_bank_details_page
    and_i_fill_in_my_refund_building_society_details_with \
      [
        { field: 'account_name', value: 'Luke Skywalker' },
        { field: 'building_society_name', value: 'Bank Name' },
        { field: 'account_number', value: '123456789' },
        { field: 'sort_code', value: '1234567' }
      ]
    and_i_save_the_refund_bank_details
    then_the_building_society_account_number_field_should_be_marked_with_an_invalid_error_in_the_refund_bank_details_page
    then_the_building_society_sort_code_field_should_be_marked_with_an_invalid_error_in_the_refund_bank_details_page
  end
end
