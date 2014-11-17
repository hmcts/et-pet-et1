require 'rails_helper'

feature 'Terms' do

  let(:general_header)           { "<h2>Terms and conditions - General</h2>" }
  let(:applicable_law_header)    { "<h1>Applicable law</h1>" }
  let(:privacy_policy_header)    { "<h1>Privacy policy - Information provided by this service</h1>" }
  let(:data_protection_header)   { "<h1>Data Protection Act 1998</h1>" }
  let(:disclaimer_header)        { "<h1>Disclaimer</h1>" }

  before :each do
    visit terms_path
  end

  scenario "User visits the terms page" do
    expect(page.html).to include(general_header)
    expect(page.html).to include(applicable_law_header)
    expect(page.html).to include(privacy_policy_header)
    expect(page.html).to include(data_protection_header)
    expect(page.html).to include(disclaimer_header)
  end

  let(:general_link)          { "Terms and conditions - General" }
  let(:applicable_law_link)   { "Applicable law" }
  let(:privacy_policy_link)   { "Privacy policy - Information provided by this service" }
  let(:data_protection_link)  { "Data Protection Act 1998" }
  let(:disclaimer_link)       { "Disclaimer" }

  let(:general_div)           { "#general" }
  let(:applicable_law_div)    { "#applicable_law" }
  let(:privacy_policy_div)    { "#privacy_policy" }
  let(:data_protection_div)   { "#data_protection" }
  let(:disclaimer_div)        { "#disclaimer" }

  scenario "User can click general link" do
    expect(page).to have_link(general_link, href: "#{terms_path + general_div}")
    expect(page.find(general_div)).not_to be_nil
  end

  scenario "User can click applicable law link" do
    expect(page).to have_link(applicable_law_link, href: "#{terms_path + applicable_law_div}")
    expect(page.find(applicable_law_div)).not_to be_nil
  end

  scenario "User can click privacy policy link" do
    expect(page).to have_link(privacy_policy_link, href: "#{terms_path + privacy_policy_div}")
    expect(page.find(privacy_policy_div)).not_to be_nil
  end

  scenario "User can click data protection link" do
    expect(page).to have_link(data_protection_link, href: "#{terms_path + data_protection_div}")
    expect(page.find(data_protection_div)).not_to be_nil
  end

  scenario "User can click disclaimer link" do
    expect(page).to have_link(disclaimer_link, href: "#{terms_path + disclaimer_div}")
    expect(page.find(disclaimer_div)).not_to be_nil
  end

end
