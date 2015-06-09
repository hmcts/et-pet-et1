require 'rails_helper'

RSpec.feature 'Claim statistics', type: :feature do
  before do
    allow(Stats::ClaimStats).to receive(:started_count)   { 10 }
    allow(Stats::ClaimStats).to receive(:completed_count) { 15 }
  end

  scenario 'hitting the stats end point returns json' do
    visit stats_path format: 'json'

    expect(page.response_headers['Content-Type']).to match('application/json')
    expect(page.body).to eq({ started_claims: 10, completed_claims: 15 }.to_json)
  end
end
