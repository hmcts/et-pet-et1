module Refunds
  class ProfileSelectionPage < BasePage
    section :select_profile, AppTest::FormRadioButtons, :simple_form_radio_buttons, 'Please confirm that you are the following'
    element :save_and_continue, 'input[value="Continue"]'
  end

end
