And(/^I debug$/) do
  sleep 1
  expect(false).to eql(true), "Debugger - used to cause test to fail and a screenshot be saved"
end

And(/^I sleep for (\d+) seconds$/) do |arg|
  sleep arg.to_f
end


And(/^I take a screenshot$/) do
  screenshot_and_save_page
end
