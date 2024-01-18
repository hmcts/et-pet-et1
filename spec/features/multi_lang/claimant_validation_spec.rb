require 'rails_helper'
RSpec.describe 'Claimant Validation', js: true, type: :feature do
  it 'filters out an incorrect phone number and provides the correct message' do
    # Arrange - get to the page loaded with a claimant with the phone number overridden
    claimant = build(:ui_claimant, :mandatory, phone_or_mobile_number: 'somethingwromg', alternative_phone_or_mobile_number: 'something_wrong')

    apply_page.load
    apply_page.start_a_claim
    saving_your_claim_page.register(email_address: 'fred@bloggs.com', password: 'password')
    claimants_details_page.fill_in_all(claimant: claimant)

    # ACT - Click the save and continue button
    claimants_details_page.save_and_continue

    # Assert - check the error messages
    claimants_details_page.assert_error_messages phone_or_mobile_number: 'claimants_details.errors.invalid_phone_number',
                                                 alternative_phone_or_mobile_number: 'claimants_details.errors.invalid_phone_number'

  end

  it 'filters out a missing allow video attendance and provides the correct message' do
    # Arrange - get to the page loaded with a claimant with the phone number overridden
    claimant = build(:ui_claimant, :mandatory, allow_video_attendance: nil)

    apply_page.load
    apply_page.start_a_claim
    saving_your_claim_page.register(email_address: 'fred@bloggs.com', password: 'password')
    claimants_details_page.fill_in_all(claimant: claimant)

    # ACT - Click the save and continue button
    claimants_details_page.save_and_continue

    # Assert - check the error messages
    claimants_details_page.assert_error_messages allow_video_attendance: 'claimants_details.errors.allow_video_attendance.blank'
  end
end
