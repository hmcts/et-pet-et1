require 'rails_helper'

RSpec.describe 'Dynatrace script tag', type: :feature, js: false do
  context 'with value specified' do
    around do |example|
      previous_value = Rails.application.config.dynatrace_ui_tracking_id
      Rails.application.config.dynatrace_ui_tracking_id = '123456/7890'
      example.run
    ensure
      Rails.application.config.dynatrace_ui_tracking_id = previous_value
    end

    it 'returns the correct script tag' do
      visit root_path
      expect(page).to have_selector('script[type="text/javascript"][src="https://js-cdn.dynatrace.com/jstag/17177a07246/123456/7890_complete.js"][crossorigin="anonymous"]', visible: :all)
    end
  end
end
