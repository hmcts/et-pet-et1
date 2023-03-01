require 'rails_helper'

describe 'Terms' do

  let(:general_header)                                 { '<h2 class="legend">General terms and conditions</h2>' }
  let(:applicable_law_header)                          { '<h2 class="legend">Applicable Law</h2>' }
  let(:applicable_law_responsible_use_header)          { '<h2 class="legend">Responsible use of this service</h2>' }
  let(:data_protection_header)                         { '<h2 class="legend">General Data Protection Regulations (GDPR)</h2>' }
  let(:privacy_policy_header)                          { '<h2 class="legend">HMCTS privacy notice</h2>' }
  let(:privacy_policy_purpose_header)                  { '<h3>Purpose</h3>' }
  let(:privacy_policy_about_data_header)               { '<h3>About personal data</h3>' }
  let(:privacy_policy_personal_data_collection_header) { '<h3>Personal data that we collect</h3>' }
  let(:privacy_policy_personal_information_header)     { '<h3>How we use your personal data</h3>' }
  let(:privacy_policy_non_personal_information_header) { '<h3>How we use non-personal data</h3>' }
  let(:privacy_policy_data_storage_header)             { '<h3>How your personal data is stored</h3>' }
  let(:privacy_policy_non_personal_data_storage_header) { '<h3>How non-personal data is stored</h3>' }
  let(:privacy_policy_secure_data)                     { '<h3>Keeping your data secure</h3>' }
  let(:privacy_policy_disclosing_data)                 { '<h3>Disclosing your data</h3>' }
  let(:session_management_header)                      { '<h3>How we manage sessions</h3>' }
  let(:access_to_information)                          { '<h3>Access to personal information</h3>' }
  let(:complaints)                                     { '<h3>Complaints</h3>' }

  let(:disclaimer_header)                              { '<h2 class="legend">Disclaimer</h2>' }

  let(:general_link)                                  { "General terms and conditions" }
  let(:applicable_law_link)                           { "Applicable law" }
  let(:applicable_law_responsible_use_link)           { "Responsible use of this service" }
  let(:privacy_policy_link)                           { "HMCTS privacy notice" }
  let(:data_protection_link)                          { "General Data Protection Regulations (GDPR)" }
  let(:disclaimer_link)                               { "Disclaimer" }

  let(:general_div)                                 { "#general" }
  let(:applicable_law_div)                          { "#applicable_law" }
  let(:applicable_law_responsible_use_div)          { "#responsible" }
  let(:privacy_policy_div)                          { "#hmcts_privacy" }
  let(:privacy_policy_personal_information_div)     { "#privacy_policy_personal_information" }
  let(:privacy_policy_non_personal_information_div) { "#privacy_policy_non_personal_information" }
  let(:privacy_policy_data_storage_div)             { "#privacy_policy_data_storage" }
  let(:session_management_div)                      { "#session_management" }
  let(:data_protection_div)                         { "#gdpr" }
  let(:disclaimer_div)                              { "#disclaimer" }

  before do
    visit terms_path
  end

  it "User visits the terms page" do
    expect(page.html).to include(general_header)
    expect(page.html).to include(applicable_law_header)
    expect(page.html).to include(applicable_law_responsible_use_header)
    expect(page.html).to include(data_protection_header)
    expect(page.html).to include(privacy_policy_header)
    expect(page.html).to include(privacy_policy_purpose_header)
    expect(page.html).to include(privacy_policy_about_data_header)
    expect(page.html).to include(privacy_policy_personal_data_collection_header)
    expect(page.html).to include(privacy_policy_personal_information_header)
    expect(page.html).to include(privacy_policy_non_personal_information_header)
    expect(page.html).to include(privacy_policy_data_storage_header)
    expect(page.html).to include(privacy_policy_non_personal_data_storage_header)
    expect(page.html).to include(privacy_policy_secure_data)
    expect(page.html).to include(privacy_policy_disclosing_data)
    expect(page.html).to include(session_management_header)
    expect(page.html).to include(access_to_information)
    expect(page.html).to include(complaints)

    expect(page.html).to include(disclaimer_header)
  end

  it "User can click general link" do
    expect(page).to have_link(general_link, href: general_div.to_s)
    expect(page.find(general_div)).not_to be_nil
  end

  it "User can click applicable law link" do
    expect(page).to have_link(applicable_law_link, href: applicable_law_div.to_s)
    expect(page.find(applicable_law_div)).not_to be_nil
  end

  it "User can click applicable law responsible use link" do
    expect(page).to have_link(applicable_law_responsible_use_link, href: applicable_law_responsible_use_div.to_s)
    expect(page.find(applicable_law_div)).not_to be_nil
  end

  it "User can click privacy policy link" do
    expect(page).to have_link(privacy_policy_link, href: privacy_policy_div.to_s)
    expect(page.find(privacy_policy_div)).not_to be_nil
  end

  it "User can click data protection link" do
    expect(page).to have_link(data_protection_link, href: data_protection_div.to_s)
    expect(page.find(privacy_policy_div)).not_to be_nil
  end

  it "User can click disclaimer link" do
    expect(page).to have_link(disclaimer_link, href: disclaimer_div.to_s)
    expect(page.find(privacy_policy_div)).not_to be_nil
  end
end
