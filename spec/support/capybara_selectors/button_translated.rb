Capybara.add_selector(:button_translated) do
  xpath do |locator, **options|
    translated = ET1::Test::Messaging.instance.translate(locator)
      expression_for(:button, translated, **options)
    end
end
