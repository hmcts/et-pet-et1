require 'rails_helper'

RSpec.feature 'Feedback form' do
  before { stub_request(:post, /.+/) }

  scenario 'filling in the feedback form' do
    visit feedback_path

    expect(page).not_to have_signout_button

    fill_in 'Have you had any problems using this service?',  with: 'lél'
    fill_in 'Do you have any other comments or suggestions?', with: 'get #rekt'
    fill_in 'Your email address',                             with: 'lewl@example.com'

    click_button 'Send feedback'

    expect(page).to have_text "Thank you for your feedback"
  end
end
