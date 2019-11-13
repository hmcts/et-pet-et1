Capybara.add_selector(:fieldset_translated) do
  xpath do |locator, _options|
    translated = ET1::Test::Messaging.instance.translate(locator)
    XPath.generate { |x| x.descendant(:fieldset)[x.child(:legend)[x.string.n.is(translated)]] }
  end
end
