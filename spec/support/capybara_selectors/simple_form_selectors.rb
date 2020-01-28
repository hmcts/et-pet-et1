Capybara.add_selector(:simple_form_field) do
  xpath do |locator, options|
    xpath = XPath.child(:input, :textarea, :select)[~XPath.attr(:type).one_of('submit', 'image', 'hidden')]
    XPath.descendant(:div)[locate_field(xpath, locator, options)]
  end
end
Capybara.add_selector(:simple_form_date) do
  xpath do |locator, _options|
    XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is(locator)]] }
  end
end

Capybara.add_selector(:simple_form_boolean) do
  xpath do |locator, _options|
    XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is(locator)]] }
  end
end

Capybara.add_selector(:simple_form_radio_buttons) do
  xpath do |locator, _options|
    XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is(locator)]] }
  end
end
