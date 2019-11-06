Capybara.add_selector(:link_or_button_translated) do
  xpath do |locator, **options|
    translated = ET1::Test::Messaging.instance.translate(locator)
      expression_for(:link_or_button, translated, **options)
    end
end
