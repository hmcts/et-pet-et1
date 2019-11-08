Capybara.add_selector(:checkbox_question_labelled_translated) do
  xpath do |locator, _options|
    translated = ET1::Test::Messaging.instance.translate(locator)
    XPath.generate { |x| x.descendant(:div)[x.child(:span)[x.child(:label)[x.string.n.is(translated)]]] }
  end
end
