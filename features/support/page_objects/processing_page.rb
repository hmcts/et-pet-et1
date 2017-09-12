class ProcessingPage < BasePage
  element :processing_header, :xpath, (XPath.generate { |x| x.descendant(:header)[x.descendant(:h1)[x.string.n.is("Processing a copy of your claim")]] })

end
