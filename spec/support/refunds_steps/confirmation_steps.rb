def then_i_should_see_a_valid_confirmation_page_for_a_claimant
  expect(refund_confirmation_page.reference_number.text).to start_with("C")
  expect(refund_confirmation_page.reference_number.text).to match(/(C|R)\d\d\d\d\d\d/)
  expect(refund_confirmation_page.submitted_date.text).to match(/\d{1,2} (?:January|February|March|April|May|June|July|August|September|October|November|December) \d{4}/)
end
