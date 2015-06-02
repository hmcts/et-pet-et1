require 'rails_helper'

RSpec.feature 'Claim statistics', type: :feature do
  before do
    allow(Stats::ClaimStats).to receive(:started_count)   { 10 }
    allow(Stats::ClaimStats).to receive(:completed_count) { 15 }
    allow(Stats::ClaimStats).to receive(:paid_count)      { 20 }
    allow(Stats::ClaimStats).to receive(:remission_count) { 25 }
  end

  scenario 'hitting the stats end point returns json' do
    visit stats_path format: 'json'

    expect(page.response_headers['Content-Type']).to match('application/json')

    expected_json = {
      started_count: 10,
      completed_count: 15,
      paid_count: 20,
      remission_count: 25
    }.to_json

    expect(page.body).to eq expected_json
  end
end
