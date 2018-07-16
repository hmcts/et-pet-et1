require 'rails_helper'

feature 'Terms' do

  let(:general_header)                                 { '<h2 class="legend">General Terms and Conditions</h2>' }
  let(:applicable_law_header)                          { '<h2 class="legend">Applicable Law</h2>' }
  let(:applicable_law_responsible_use_header)          { '<h2 class="legend">Responsible use of this service</h2>' }
  let(:data_protection_header)                         { '<h2 class="legend">General Data Protection Regulations (GDPR)</h2>' }
  let(:privacy_policy_header)                          { '<h2 class="legend">HMCTS Privacy Notice</h2>' }
  let(:privacy_policy_purpose_header)                  { '<h2>Purpose</h2>' }
  let(:privacy_policy_about_data_header)               { '<h2>About personal data</h2>' }
  let(:privacy_policy_personal_data_collection_header) { '<h2>Personal Data That We Collect</h2>' }
  let(:privacy_policy_personal_information_header)     { '<h2>How we use your personal data</h2>' }
  let(:privacy_policy_non_personal_information_header) { '<h2>How we use non-personal data</h2>' }
  let(:privacy_policy_data_storage_header)             { '<h2>How your personal data is stored</h2>' }
  let(:privacy_policy_non_personal_data_storage_header) { '<h2>How non-personal data is stored</h2>' }
  let(:privacy_policy_secure_data)                     { '<h2>Keeping your data secure</h2>' }
  let(:privacy_policy_disclosing_data)                 { '<h2>Disclosing your data</h2>' }
  let(:session_management_header)                      { '<h2>How we manage sessions</h2>' }
  let(:access_to_information)                          { '<h2>Access to personal information</h2>' }
  let(:complaints)                                     { '<h2>Complaints</h2>' }

  let(:disclaimer_header)                              { '<h2 class="legend">Disclaimer</h2>' }

  let(:general_link)                                  { "General Terms and conditions" }
  let(:applicable_law_link)                           { "Applicable law" }
  let(:applicable_law_responsible_use_link)           { "Responsible use of this service" }
  let(:privacy_policy_link)                           { "HMCTS Privacy Notice" }
  let(:data_protection_link)                          { "General Data Protection Regulations (GDPR)" }
  let(:disclaimer_link)                               { "Disclaimer" }

  let(:general_div)                                 { "#general" }
  let(:applicable_law_div)                          { "#applicable_law" }
  let(:applicable_law_responsible_use_div)          { "#applicable_law_responsible_use" }
  let(:privacy_policy_div)                          { "#privacy_policy" }
  let(:privacy_policy_personal_information_div)     { "#privacy_policy_personal_information" }
  let(:privacy_policy_non_personal_information_div) { "#privacy_policy_non_personal_information" }
  let(:privacy_policy_data_storage_div)             { "#privacy_policy_data_storage" }
  let(:online_payment_div)                          { "#online_payment" }
  let(:session_management_div)                      { "#session_management" }
  let(:data_protection_div)                         { "#data_protection" }
  let(:disclaimer_div)                              { "#disclaimer" }

  before do
    visit terms_path
  end

  scenario "User visits the terms page" do
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

  scenario "User can click general link" do
    expect(page).to have_link(general_link, href: (terms_path + general_div).to_s)
    expect(page.find(general_div)).not_to be_nil
  end

  scenario "User can click applicable law link" do
    expect(page).to have_link(applicable_law_link, href: (terms_path + applicable_law_div).to_s)
    expect(page.find(applicable_law_div)).not_to be_nil
  end

  scenario "User can click applicable law responsible use link" do
    expect(page).to have_link(applicable_law_responsible_use_link, href: (terms_path + applicable_law_responsible_use_div).to_s)
    expect(page.find(applicable_law_div)).not_to be_nil
  end

  scenario "User can click privacy policy link" do
    expect(page).to have_link(privacy_policy_link, href: (terms_path + privacy_policy_div).to_s)
    expect(page.find(privacy_policy_div)).not_to be_nil
  end

  scenario "User can click data protection link" do
    expect(page).to have_link(data_protection_link, href: (terms_path + data_protection_div).to_s)
    expect(page.find(privacy_policy_div)).not_to be_nil
  end

  scenario "User can click disclaimer link" do
    expect(page).to have_link(disclaimer_link, href: (terms_path + disclaimer_div).to_s)
    expect(page.find(privacy_policy_div)).not_to be_nil
  end
end
