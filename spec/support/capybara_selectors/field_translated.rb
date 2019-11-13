Capybara.add_selector(:field_translated) do
  xpath do |locator, **options|
    translated = ET1::Test::Messaging.instance.translate(locator)
      expression_for(:field, translated, **options)
    end
end
