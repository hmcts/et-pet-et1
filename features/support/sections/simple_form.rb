module AppTest
  class FormSelect < SitePrism::Section
    def set(value)
      field.select(value)
    end
    element :field, 'select'
    element :label, 'label'
    element :error, '.error'
  end

  class FormInput < SitePrism::Section
    delegate :set, to: :field
    element :field, 'input'
    element :label, 'label'
    element :error, '.error'
  end

  class FormBoolean < SitePrism::Section
    element :field, 'input'
    element :label, 'label'
    element :error, '.error'
    def set(value)
      within @root_element do
        choose(value)
      end
    end
  end

  class FormRadioButtons < SitePrism::Section
    element :field, 'input'
    element :label, 'label'
    element :error, '.error'
    def set(value)
      within @root_element do
        choose(value)
      end
    end
  end

  class FormDate < SitePrism::Section
    element :day, :field, 'Day'
    element :month, :field, 'Month'
    element :year, :field, 'Year'
    element :label, 'label'
    element :error, '.error'
    def set(value)
      (day_value, month_value, year_value) = value.split("/")
      day.set(day_value)
      month.set(month_value)
      year.set(year_value)
    end
  end

end
