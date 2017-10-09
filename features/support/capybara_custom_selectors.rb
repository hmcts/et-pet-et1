Capybara.add_selector(:simple_form_field) do
  xpath do |locator, options|
    xpath = XPath.descendant(:input, :textarea, :select)[~XPath.attr(:type).one_of('submit', 'image', 'hidden')]
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

Capybara.add_selector(:refund_review_section_labelled) do
  xpath do |locator, _options|
    XPath.generate { |x| x.descendant(:div)[x.attr(:'data-behavior').equals('refund-review-section').and(x.descendant(:h2)[x.descendant(:span)[x.string.n.is(locator)]])] }
  end
end

Capybara.add_selector(:refund_review_section_field_labelled) do
  xpath do |locator, _options|
    XPath.generate { |x| x.descendant(:table).descendant(:tr)[x.descendant(:th)[x.string.n.is(locator)]].descendant(:td) }
  end
end

Capybara.add_selector(:refund_review_section_fee_type_labelled) do
  xpath do |locator, _options|
    XPath.generate { |x| x.descendant(:table).descendant(:tr)[x.descendant(:th)[x.string.n.is(locator)]] }
  end
end

Capybara.add_selector(:flash_message_with_text) do
  xpath do |locator, _options|
    XPath.generate { |x| x.descendant(:h2)[x.ancestor(:div)[x.attr(:class).contains('flash').and(x.string.equals(locator))]] }
  end
end
