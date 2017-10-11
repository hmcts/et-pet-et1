debug_screenshots_disabled = ENV.fetch('DISABLE_DEBUG_SCREENSHOTS', 'false').casecmp('true').zero?
And(/^I debug$/) do
  sleep 1
  expect(false).to eql(true), "Debugger - used to cause test to fail and a screenshot be saved"
end

And(/^I sleep for (\d+) seconds$/) do |arg|
  sleep arg.to_f
end

And(/^I take a screenshot$/) do
  next if debug_screenshots_disabled
  screenshot_and_save_page
end

And(/^I take a screenshot named "([^"]*)"$/) do |filename_prefix|
  next if debug_screenshots_disabled
  Capybara.using_session(Capybara::Screenshot.final_session_name) do

    saver = Capybara::Screenshot.new_saver(Capybara, Capybara.page, true, filename_prefix)
    saver.save
    saver.output_screenshot_path

    # Trying to embed the screenshot into our output."
    if File.exist?(saver.screenshot_path)
      require "base64"
      # encode the image into it's base64 representation
      image = open(saver.screenshot_path, 'rb', &:read)
      saver.display_image
      # this will embed the image in the HTML report, embed() is defined in cucumber
      encoded_img = Base64.encode64(image)
      embed(encoded_img, 'image/png;base64', filename_prefix)
    end
  end

end
