module ET1
  module Test
    class RadioButtonsQuestionSection < BaseSection
      def set(value)
        root_element.choose(translate_if_needed value)
      end

      private


    end
  end
end
