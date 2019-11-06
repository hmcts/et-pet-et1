module ET1
  module Test
    class DateQuestionSection < BaseSection
      def set(value)
        if value.nil?
          [day_element, month_element, year_element].each {|e| e.set('')}
        else
          day, month, year = value.split('/')
          day_element.set(day)
          month_element.set(month)
          year_element.set(year)
        end
      end

      private

      element :day_element, :field_translated, 'components.date.day'
      element :month_element, :field_translated, 'components.date.month'
      element :year_element, :field_translated, 'components.date.year'
    end
  end
end
