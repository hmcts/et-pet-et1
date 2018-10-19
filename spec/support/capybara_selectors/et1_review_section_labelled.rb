Capybara.add_selector(:et1_review_section_labelled) do
  xpath do |locator, _options|
    translated = ET1::Test::Messaging.instance.translate(locator)
    XPath.generate do |x|
      x.descendant(:div)[x.child(:h2)[x.string.n.starts_with(translated)]]
    end
  end
end
