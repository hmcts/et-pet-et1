module ET1
  module Test
    class SidebarSection < BaseSection
      def save_and_complete_later
        save_and_complete_later_element.click
        SaveAndCompleteLaterPage.new
      end

      def guide
        guide_element.click
        GuidePage.new
      end

      private

      element :save_and_complete_later_element, :link_or_button_translated, :'claimants_details.save_and_complete_later'
      element :guide_element, :link_or_button_translated, :'components.sidebar.guide'
    end
  end
end
