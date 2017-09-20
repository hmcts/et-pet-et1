module Refunds
  class ProfileSelectionPage < BasePage
    section :select_profile, '.profile_selection' do
      def set(value)
        choose(value)
      end
    end
    element :save_and_continue, 'input[value="Continue"]'
  end

end
