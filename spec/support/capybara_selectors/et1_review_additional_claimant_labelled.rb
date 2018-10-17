Capybara.add_selector(:et1_review_additional_claimant_labelled) do
  xpath do |locator, _options|
    translated = ET1::Test::Messaging.instance.translate(locator)
    XPath.generate do |x|
      x.css('table.review-table')[x.child(:caption)[x.string.n.starts_with(translated)]]
    end
  end
end
