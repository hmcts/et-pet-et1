And(/^I debug$/) do
  sleep 1
  expect(false).to eql(true), "Debugger - used to cause test to fail and a screenshot be saved"
end
