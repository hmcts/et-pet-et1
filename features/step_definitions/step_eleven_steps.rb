And(/^I answer Yes to the other important details question$/) do
  step_eleven_page.other_important_details.set("Yes")
end


And(/^I fill in the important details with "([^"]*)"$/) do |value|
  step_eleven_page.other_important_details.notes.set(value)
end


And(/^I save the more about the claim form$/) do
  step_eleven_page.save_and_continue.click
end
