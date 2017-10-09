module Refunds
  class ProfileSelectionPage < BasePage
    set_url "/apply/refund/profile-selection"
    section :select_profile, AppTest::FormRadioButtons, :simple_form_radio_buttons, 'Please confirm that you are the following'
    element :session_reloaded_message, :flash_message_with_text, 'Your session has been re loaded - this may have been caused by your cookie expiring'
    element :save_and_continue, 'input[value="Continue"]'
  end

end
