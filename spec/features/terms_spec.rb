require 'rails_helper'

feature 'Terms' do

  let(:general_header)                                 { '<h2 class="legend">General terms and conditions</h2>' }
  let(:applicable_law_header)                          { '<h2 class="legend">Applicable law</h2>' }
  let(:applicable_law_responsible_use_header)          { '<h3>Responsible use of this service</h3>' }
  let(:privacy_policy_header)                          { '<h1>Privacy policy</h1>' }
  let(:privacy_policy_personal_information_header)     { '<h2 class="legend">How we use your personal information</h2>' }
  let(:privacy_policy_non_personal_information_header) { '<h2 class="legend">How we use non-personal information</h2>' }
  let(:privacy_policy_data_storage_header)             { '<h2 class="legend">How we keep your information safe</h2>' }
  let(:online_payment_header)                          { '<h2 class="legend">Online payment</h2>' }
  let(:session_management_header)                      { '<h2 class="legend">How we manage sessions</h2>' }
  let(:data_protection_header)                         { '<h2 class="legend">Data Protection Act (DPA) 1998</h2>' }
  let(:disclaimer_header)                              { '<h2 class="legend">Disclaimer</h2>' }
  let(:cookies_header)                                 { '<h2 class="legend">Cookies</h2>' }

  before :each do
    visit terms_path
  end

  scenario "User visits the terms page" do
    expect(page.html).to include(general_header)
    expect(page.html).to include(applicable_law_header)
    expect(page.html).to include(applicable_law_responsible_use_header)
    expect(page.html).to include(privacy_policy_header)
    expect(page.html).to include(privacy_policy_personal_information_header)
    expect(page.html).to include(privacy_policy_non_personal_information_header)
    expect(page.html).to include(privacy_policy_data_storage_header)
    expect(page.html).to include(online_payment_header)
    expect(page.html).to include(session_management_header)
    expect(page.html).to include(data_protection_header)
    expect(page.html).to include(disclaimer_header)
    expect(page.html).to include(cookies_header)
  end

  let(:general_link)                                  { "Terms and conditions - General" }
  let(:applicable_law_link)                           { "Applicable law" }
  let(:applicable_law_responsible_use_link)           { "Responsible use of this service" }
  let(:privacy_policy_link)                           { "Privacy policy" }
  let(:privacy_policy_personal_information_link)      { "How we use your personal information" }
  let(:privacy_policy_non_personal_information_link)  { "How we use non-personal information" }
  let(:privacy_policy_data_storage_link)              { "How we keep your information safe" }
  let(:online_payment_link)                           { "Online payment" }
  let(:session_management_link)                       { "How we manage sessions" }
  let(:data_protection_link)                          { "Data Protection Act 1998" }
  let(:disclaimer_link)                               { "Disclaimer" }
  let(:cookies_link)                                  { "Cookies" }

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
  let(:cookies_div)                                 { "#cookies" }

  scenario "User can click general link" do
    expect(page).to have_link(general_link, href: "#{terms_path + general_div}")
    expect(page.find(general_div)).not_to be_nil
  end

  scenario "User can click applicable law link" do
    expect(page).to have_link(applicable_law_link, href: "#{terms_path + applicable_law_div}")
    expect(page.find(applicable_law_div)).not_to be_nil
  end

  scenario "User can click applicable law responsible use link" do
    expect(page).to have_link(applicable_law_responsible_use_link, href: "#{terms_path + applicable_law_responsible_use_div}")
    expect(page.find(applicable_law_div)).not_to be_nil
  end

  scenario "User can click privacy policy link" do
    expect(page).to have_link(privacy_policy_link, href: "#{terms_path + privacy_policy_div}")
    expect(page.find(privacy_policy_div)).not_to be_nil
  end

  scenario "User can click privacy policy personal information link" do
    expect(page).to have_link(privacy_policy_personal_information_link, href: "#{terms_path + privacy_policy_personal_information_div}")
    expect(page.find(privacy_policy_div)).not_to be_nil
  end

  scenario "User can click privacy policy non personal information link" do
    expect(page).to have_link(privacy_policy_non_personal_information_link, href: "#{terms_path + privacy_policy_non_personal_information_div}")
    expect(page.find(privacy_policy_div)).not_to be_nil
  end

  scenario "User can click privacy policy data storage link" do
    expect(page).to have_link(privacy_policy_data_storage_link, href: "#{terms_path + privacy_policy_data_storage_div}")
    expect(page.find(privacy_policy_div)).not_to be_nil
  end

  scenario "User can click online payment link" do
    expect(page).to have_link(online_payment_link, href: "#{terms_path + online_payment_div}")
    expect(page.find(privacy_policy_div)).not_to be_nil
  end

  scenario "User can click session management link" do
    expect(page).to have_link(session_management_link, href: "#{terms_path + session_management_div}")
    expect(page.find(privacy_policy_div)).not_to be_nil
  end

  scenario "User can click data protection link" do
    expect(page).to have_link(data_protection_link, href: "#{terms_path + data_protection_div}")
    expect(page.find(privacy_policy_div)).not_to be_nil
  end

  scenario "User can click disclaimer link" do
    expect(page).to have_link(disclaimer_link, href: "#{terms_path + disclaimer_div}")
    expect(page.find(privacy_policy_div)).not_to be_nil
  end

  scenario "User can click cookies link" do
    expect(page).to have_link(cookies_link, href: "#{terms_path + cookies_div}")
    expect(page.find(privacy_policy_div)).not_to be_nil
  end
end
