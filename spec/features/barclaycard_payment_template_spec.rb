require 'rails_helper'

RSpec.feature 'Barclaycard payment template' do
  before do
    allow(ENV).to receive(:fetch).
      with('ASSET_HOST').
      and_return('https://example.com')

    visit 'apply/barclaycard-payment-template'
  end

  it 'renders a page that allows barclaycard to inject content' do
    expect(page).to have_text 'Pay your fee'
    expect(page).to have_css '.main-content.payment-zone', text: '$$$PAYMENT ZONE$$$'
  end

  it 'provides absolute paths to assets' do
    page.all('//link', visible: false).each do |link|
      expect(link['href']).to match(/\A(https:\/\/example.com)/)
    end
  end
end
