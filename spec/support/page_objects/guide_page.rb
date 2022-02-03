require_relative './base_page'
module ET1
  module Test
    class GuidePage < BasePage
      set_url "/en/apply/guide"

      def return_to_form
        return_to_form_element.click
      end

      private

      element :return_to_form_element, :link_or_button_translated, :'components.sidebar.guide'
    end
  end
end
