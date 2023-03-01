require 'rails_helper'
RSpec.describe 'Refund Validations - Profile selection page', js: true do
  # In order to ensure that the user is
  # of a particular profile, profile selection with validation is required to make
  # sure the user has selected a valid profile before they move on to the next step
  before do
    and_i_start_a_new_refund
  end

  it 'A user does not fill in any fields in the applicant step' do
    and_i_save_my_profile_selection_on_the_refund_type_page
    then_the_continue_button_should_be_disabled_on_the_profile_selection_page
  end
end
