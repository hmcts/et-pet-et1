Capybara.add_selector(:refund_review_section_labelled) do
  xpath do |locator, _options|
    XPath.generate do |x|
      x.descendant(:dl)[
        x.attr(:class)
         .contains_word('govuk-summary-list')
         .and(x.preceding_sibling(:h2)[1][x.string.n.is(locator)])
      ]
    end
  end
end

Capybara.add_selector(:refund_review_section_field_labelled) do
  xpath do |locator, _options|
    XPath.generate do |x|
      x.descendant(:dd)[x.attr(:class).contains_word('govuk-summary-list__value') &
          x.preceding_sibling(:dt)[
            x.attr(:class).contains_word('govuk-summary-list__key') & x.string.n.is(locator)
          ]
      ]
    end
  end
end

Capybara.add_selector(:refund_review_section_fee_type_labelled) do
  xpath do |locator, _options|
    XPath.generate do |x|
      x.descendant(:div)[x.attr(:class).contains_word('fee') &
        x.preceding_sibling(:h2)[1][x.string.n.is(locator)]
      ]
    end
  end
end

Capybara.add_selector(:refund_review_section_fee_summary_labelled) do
  xpath do |locator, _options|
    XPath.generate do |x|
      x.descendant(:div)[x.preceding_sibling(:h2)[1][x.string.n.is(locator)]
      ]
    end
  end
end
