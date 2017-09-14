And(/^I accept the refund final declaration$/) do
  refund_review_page.declaration.set("Yes")
  step('I take a screenshot named "Page 5 - Review"')
  refund_review_page.save_and_continue.click
end


And(/^I save the final refund$/) do
  refund_review_page.save_and_continue.click
end
