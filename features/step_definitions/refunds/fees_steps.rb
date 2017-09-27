Then(/^all fee payment method fields in the fees page should be marked with an error$/) do
  expect(refund_fees_page.original_claim_fees.et_issue.payment_method.error.text).to eql 'Please select a payment method'
  expect(refund_fees_page.original_claim_fees.et_hearing.payment_method.error.text).to eql 'Please select a payment method'
  expect(refund_fees_page.original_claim_fees.et_reconsideration.payment_method.error.text).to eql 'Please select a payment method'
  expect(refund_fees_page.original_claim_fees.eat_issue.payment_method.error.text).to eql 'Please select a payment method'
  expect(refund_fees_page.original_claim_fees.eat_hearing.payment_method.error.text).to eql 'Please select a payment method'
end

Then(/^all fee payment date fields in the fees page should be marked with an error$/) do
  expect(refund_fees_page.original_claim_fees.et_issue.payment_date.error.text).to eql 'Please enter the payment year and month or tick \'Don\'t know\''
  expect(refund_fees_page.original_claim_fees.et_hearing.payment_date.error.text).to eql 'Please enter the payment year and month or tick \'Don\'t know\''
  expect(refund_fees_page.original_claim_fees.et_reconsideration.payment_date.error.text).to eql 'Please enter the payment year and month or tick \'Don\'t know\''
  expect(refund_fees_page.original_claim_fees.eat_issue.payment_date.error.text).to eql 'Please enter the payment year and month or tick \'Don\'t know\''
  expect(refund_fees_page.original_claim_fees.eat_hearing.payment_date.error.text).to eql 'Please enter the payment year and month or tick \'Don\'t know\''
end

Then(/^all fee payment date fields in the fees page should not be marked with an error$/) do
  expect(refund_fees_page.original_claim_fees.et_issue.payment_date).to have_no_error, 'ET issue payment date should not have an error'
  expect(refund_fees_page.original_claim_fees.et_hearing.payment_date).to have_no_error, 'ET hearing payment date should not have an error'
  expect(refund_fees_page.original_claim_fees.et_reconsideration.payment_date).to have_no_error, 'ET reconsideration payment date should not have an error'
  expect(refund_fees_page.original_claim_fees.eat_issue.payment_date).to have_no_error, 'EAT issue payment date should not have an error'
  expect(refund_fees_page.original_claim_fees.eat_hearing.payment_date).to have_no_error, 'EAT refund payment date should not have an error'
end

And(/^I fill in my refund fees$/) do
  step('I take a screenshot named "Page 4 - Fees 1"')
  test_user_fees = test_user.et_claim_to_refund.fees
  refund_fees_page.original_claim_fees.et_issue do |section|
    section.fee.set(test_user_fees.et_issue_fee) unless test_user_fees.et_issue_fee.nil?
    section.payment_method.select(test_user_fees.et_issue_payment_method) unless test_user_fees.et_issue_payment_method.nil?
    section.payment_date.set(test_user_fees.et_issue_payment_date) unless test_user_fees.et_issue_payment_date.nil?

  end
  refund_fees_page.original_claim_fees.et_hearing do |section|
    section.fee.set(test_user_fees.et_hearing_fee) unless test_user_fees.et_hearing_fee.nil?
    section.payment_method.select(test_user_fees.et_hearing_payment_method) unless test_user_fees.et_hearing_payment_method.nil?
    section.payment_date.set(test_user_fees.et_hearing_payment_date) unless test_user_fees.et_hearing_payment_date.nil?
  end
  step('I take a screenshot named "Page 4 - Fees 2"')
  refund_fees_page.original_claim_fees.et_reconsideration do |section|
    section.fee.set(test_user_fees.et_reconsideration_fee) unless test_user_fees.et_reconsideration_fee.nil?
    section.payment_method.select(test_user_fees.et_reconsideration_payment_method) unless test_user_fees.et_reconsideration_payment_method.nil?
    section.payment_date.set(test_user_fees.et_reconsideration_payment_date) unless test_user_fees.et_reconsideration_payment_date.nil?
  end
  refund_fees_page.original_claim_fees.eat_issue do |section|
    section.fee.set(test_user_fees.eat_issue_fee) unless test_user_fees.eat_issue_fee.nil?
    section.payment_method.select(test_user_fees.eat_issue_payment_method) unless test_user_fees.eat_issue_payment_method.nil?
    section.payment_date.set(test_user_fees.eat_issue_payment_date) unless test_user_fees.eat_issue_payment_date.nil?
  end
  refund_fees_page.original_claim_fees.eat_hearing do |section|
    section.fee.set(test_user_fees.eat_hearing_fee) unless test_user_fees.eat_hearing_fee.nil?
    section.payment_method.select(test_user_fees.eat_hearing_payment_method) unless test_user_fees.eat_hearing_payment_method.nil?
    section.payment_date.set(test_user_fees.eat_hearing_payment_date) unless test_user_fees.eat_hearing_payment_date.nil?
  end
  step('I take a screenshot named "Page 4 - Fees 3"')
  refund_fees_page.save_and_continue.click
end

And(/^I fill in all my refund fee values only$/) do
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

And(/^I check all my refund fee unknown dates$/) do
  refund_fees_page.original_claim_fees.et_issue.payment_date.set(:unknown)
  step('I take a screenshot named "Page 4 - Fees 3"')
  refund_fees_page.original_claim_fees.et_hearing.payment_date.set(:unknown)
  refund_fees_page.original_claim_fees.et_reconsideration.payment_date.set(:unknown)
  step('I take a screenshot named "Page 4 - Fees 4"')
  refund_fees_page.original_claim_fees.eat_issue.payment_date.set(:unknown)
  refund_fees_page.original_claim_fees.eat_hearing.payment_date.set(:unknown)
  step('I take a screenshot named "Page 4 - Fees 5"')
end
