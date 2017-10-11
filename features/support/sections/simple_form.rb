module AppTest
  class FormSelect < SitePrism::Section
    def set(value)
      field.select(value)
    end

    def get
      value = field.value
      option = options.find { |v| v.value == value }
      option ? option.text : ''
    end
    delegate :disabled?, to: :field
    element :field, 'select'
    element :label, 'label'
    element :error, '.error'
    elements :options, 'option'
  end

  class FormInput < SitePrism::Section
    delegate :set, to: :field
    element :field, 'input'
    element :label, 'label'
    element :error, '.error'
  end

  class FormTextArea < SitePrism::Section
    delegate :set, to: :field
    def get
      field.value
    end
    element :field, 'textarea'
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

  class FormPaymentDate < SitePrism::Section
    element :unknown, :field, 'Don\'t know'
    element :month, :field, 'Month'
    element :year, :field, 'Year'
    element :disabled_unknown, :field, 'Don\'t know', disabled: true
    element :disabled_month, :field, 'Month', disabled: true
    element :disabled_year, :field, 'Year', disabled: true
    element :label, 'label'
    element :error, '.error'
    def set(value)
      within @root_element do
        check("Don't know") && return if [:dont_know, :unknown, 'Don\'t know'].include?(value)
        uncheck("Don't know")
      end
      (month_value, year_value) = value.split("/")
      month.set(month_value)
      year.set(year_value)
    end

    def disabled?
      [disabled_month, disabled_year, disabled_unknown].all?(&:present?)
    end
  end
end
