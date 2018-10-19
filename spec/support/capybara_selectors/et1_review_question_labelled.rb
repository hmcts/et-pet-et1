Capybara.add_selector(:et1_review_question_labelled) do
  xpath do |locator, _options|
    translated = ET1::Test::Messaging.instance.translate(locator)
    XPath.generate do |x|
      x.descendant(:tr)[x.parent.css('table.review-table') && x.child(:th)[x.string.n.equals(translated)]]
    end
  end
end
