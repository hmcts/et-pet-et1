And(/^I accept the refund final declaration$/) do
  refund_review_page.declaration.set("Yes")
end


And(/^I save the final refund$/) do
  refund_review_page.save_and_continue.click
end
