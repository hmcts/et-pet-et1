require 'smoke_test_helper'

describe 'Smoke test', :js, type: :feature do
  include FormMethods

  after do |example|
    if example.exception
      puts "\n" + "=" * 80
      puts "SMOKE TEST FAILURE - Page HTML (first 100 lines):"
      puts "=" * 80
      puts page.html.lines.first(100).join
      puts "=" * 80
    end
  end

  let(:ui_claimant) { build(:ui_claimant, :default) }
  let(:ui_secondary_claimants) { build_list(:ui_secondary_claimant, 1, :default) }
  let(:ui_representative) { build(:ui_representative, :default) }
  let(:ui_respondent) { build(:ui_respondent, :default) }
  let(:ui_secondary_respondents) { [] }
  let(:ui_employment) { build(:ui_employment, :default) }
  let(:ui_claim_type) { build(:ui_claim_type, :default) }
  let(:ui_claim_details) { build(:ui_claim_details, :test) }
  let(:ui_claim_outcome) { build(:ui_claim_outcome, :default) }
  let(:ui_more_about_the_claim) { build(:ui_more_about_the_claim, :default) }

  it 'runs a successful smoke test', :smoke do
    expect(ENV.fetch('TEST_URL', nil)).to be_present
    ET1::Test::ApplyPage.new.load.start_a_claim
    saving_your_claim_page.register(email_address: nil, password: 'green')
    expect(claimants_details_page).to be_displayed
  end
end
