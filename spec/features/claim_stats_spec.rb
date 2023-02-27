require 'rails_helper'

RSpec.describe 'Claim statistics', type: :feature do
  before do
    allow(Stats::ClaimStats).to receive(:started_count).and_return(10)
    allow(Stats::ClaimStats).to receive(:completed_count).and_return(15)
  end

  it 'hitting the stats end point returns json' do
    visit stats_path format: 'json'

    expect(page.response_headers['Content-Type']).to match('application/json')
    expect(page.body).to eq({ started_claims: 10, completed_claims: 15 }.to_json)
  end
end
