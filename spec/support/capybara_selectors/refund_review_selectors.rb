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
