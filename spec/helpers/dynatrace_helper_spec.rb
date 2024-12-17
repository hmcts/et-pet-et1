require 'rails_helper'

RSpec.describe DynatraceHelper, type: :helper do
  context 'with value specified' do
    around do |example|
      previous_value = Rails.application.config.dynatrace_ui_tracking_id
      Rails.application.config.dynatrace_ui_tracking_id = '123456/7890'
      example.run
    ensure
      Rails.application.config.dynatrace_ui_tracking_id = previous_value
    end

    it 'returns the correct script tag' do
      content = Capybara.string(helper.dynatrace_script_tag)
      expect(content).to have_css('script[type="text/javascript"][src="https://js-cdn.dynatrace.com/jstag/17177a07246/123456/7890_complete.js"][crossorigin="anonymous"]', visible: :all)
    end
  end

  context 'with value not specified' do
    around do |example|
      previous_value = Rails.application.config.dynatrace_ui_tracking_id
      Rails.application.config.dynatrace_ui_tracking_id = nil
      example.run
    ensure
      Rails.application.config.dynatrace_ui_tracking_id = previous_value
    end

    it 'returns an empty string' do
      expect(helper.dynatrace_script_tag).to be_nil
    end
  end
end
