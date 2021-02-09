Capybara.add_selector(:question_group_labelled_translated) do
  label 'Question group labelled'
  xpath do |locator, _options|
    translated = ET1::Test::Messaging.instance.translate(locator)
    @definition.label("Question group labelled <'#{translated}'> - <#{locator}>")
    XPath.generate { |x| x.descendant(:fieldset)[x.child(:legend)[x.string.n.is(translated)]] }
  end
end
