Then(/^all fee payment method fields in the fees page should be marked with an error$/) do
  expect(refund_fees_page.original_claim_fees.et_issue.payment_method.error.text).to eql 'Please select a payment method'
  expect(refund_fees_page.original_claim_fees.et_hearing.payment_method.error.text).to eql 'Please select a payment method'
  expect(refund_fees_page.original_claim_fees.et_reconsideration.payment_method.error.text).to eql 'Please select a payment method'
  expect(refund_fees_page.original_claim_fees.eat_issue.payment_method.error.text).to eql 'Please select a payment method'
  expect(refund_fees_page.original_claim_fees.eat_hearing.payment_method.error.text).to eql 'Please select a payment method'
end

And(/^I fill in my refund fees$/) do
  step('I take a screenshot named "Page 4 - Fees 1"')
  refund_fees_page.original_claim_fees.et_issue do |section|
    section.fee.set(test_user.et_claim_to_refund.fees.et_issue_fee)
    section.payment_method.select(test_user.et_claim_to_refund.fees.et_issue_payment_method)
  end
  refund_fees_page.original_claim_fees.et_hearing do |section|
    section.fee.set(test_user.et_claim_to_refund.fees.et_hearing_fee)
    section.payment_method.select(test_user.et_claim_to_refund.fees.et_hearing_payment_method)
  end
  refund_fees_page.original_claim_fees.eat_issue do |section|
    section.fee.set(test_user.et_claim_to_refund.fees.eat_issue_fee)
    section.payment_method.select(test_user.et_claim_to_refund.fees.eat_issue_payment_method)
  end
  refund_fees_page.original_claim_fees.eat_hearing do |section|
    section.fee.set(test_user.et_claim_to_refund.fees.eat_hearing_fee)
    section.payment_method.select(test_user.et_claim_to_refund.fees.eat_hearing_payment_method)
  end
  refund_fees_page.original_claim_fees.et_reconsideration do |section|
    section.fee.set(test_user.et_claim_to_refund.fees.et_reconsideration_fee)
    section.payment_method.select(test_user.et_claim_to_refund.fees.et_reconsideration_payment_method)
  end
  step('I take a screenshot named "Page 4 - Fees 2"')
  refund_fees_page.save_and_continue.click
end

And(/^I fill in all my refund fees but do not select a payment method$/) do
  refund_fees_page.original_claim_fees.et_issue.fee.set(1)
  refund_fees_page.original_claim_fees.et_hearing.fee.set(1)
  refund_fees_page.original_claim_fees.et_reconsideration.fee.set(1)
  refund_fees_page.original_claim_fees.eat_issue.fee.set(1)
  refund_fees_page.original_claim_fees.eat_hearing.fee.set(1)
end



And(/^the fee fields in the fees page should not be marked with any errors$/) do
  aggregate_failures do
    expect(refund_fees_page.original_claim_fees.et_issue.payment_method).to have_no_error, 'Expected et issue payment method not to have an error'
    expect(refund_fees_page.original_claim_fees.et_hearing.payment_method).to have_no_error, 'Expected et hearing payment method not to have an error'
    expect(refund_fees_page.original_claim_fees.et_reconsideration.payment_method).to have_no_error, 'Expected et reconsideration payment method not to have an error'
    expect(refund_fees_page.original_claim_fees.eat_issue.payment_method).to have_no_error, 'Expected eat issue payment method not to have an error'
    expect(refund_fees_page.original_claim_fees.eat_hearing.payment_method).to have_no_error, 'Expected eat hearing payment method not to have an error'
    expect(refund_fees_page.original_claim_fees.et_issue.fee).to have_no_error, 'Expected et issue fee not to have an error'
    expect(refund_fees_page.original_claim_fees.et_hearing.fee).to have_no_error, 'Expected et hearing fee not to have an error'
    expect(refund_fees_page.original_claim_fees.et_reconsideration.fee).to have_no_error, 'Expected et reconsideration fee not to have an error'
    expect(refund_fees_page.original_claim_fees.eat_issue.fee).to have_no_error, 'Expected eat issue fee not to have an error'
    expect(refund_fees_page.original_claim_fees.eat_hearing.fee).to have_no_error, 'Expected eat hearing fee not to have an error'
  end
end


And(/^I save the refund fees$/) do
  refund_fees_page.save_and_continue.click
end
