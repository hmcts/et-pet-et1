require_relative '../base_page'
module ET1
  module Test
    module Refunds
      class ProfileSelectionPage < BasePage
        set_url "/en/apply/refund/profile-selection"
        # @!method select_profile_question
        #   A govuk radio button component for select profile question
        #   @return [EtTestHelpers::Components::GovUKCollectionRadioButtons] The site prism section
        gds_radios :select_profile_question, 'You can apply for a refund of Employment Tribunal or Employment Appeal Tribunal Fees (or both) by confirming you are one of the following:'

        element :session_reloaded_message, :flash_message_with_text, 'Your session has been re loaded - this may have been caused by your cookie expiring'
        gds_submit_button :save_and_continue, 'Continue'
      end
    end
  end
end
