require 'rails_helper'

feature 'Guide' do
  let(:time_limits_header)          { '<h2>Time limits</h2>' }
  let(:acas_header)                 { '<h2>Acas: early conciliation</h2>' }
  let(:acas_exceptions_header)      { '<h3>Exceptions to early conciliation</h3>' }
  let(:fees_header)                 { '<h2>Fees and payment</h2>' }
  let(:working_out_your_fee_header) { '<h3>Working out your fee</h3>' }
  let(:paying_your_fee_header)      { '<h3>Paying your issue fee</h3>' }
  let(:reducing_your_fee_header)    { '<h2>Reducing fees</h2>' }
  let(:writing_yours_header)        { '<h2>Writing your claim statement</h2>' }

  before :each do
    visit guide_path
  end

  scenario "User visits the guides page" do
    expect(page.html).to include(time_limits_header)
    expect(page.html).to include(acas_header)
    expect(page.html).to include(acas_exceptions_header)
    expect(page.html).to include(fees_header)
    expect(page.html).to include(working_out_your_fee_header)
    expect(page.html).to include(paying_your_fee_header)
    expect(page.html).to include(reducing_your_fee_header)
    expect(page.html).to include(writing_yours_header)
  end

  let(:time_limits_link)          { "Time limits" }
  let(:acas_link)                 { "Acas: early conciliation" }
  let(:acas_exceptions_link)      { "Exceptions to early conciliation" }
  let(:fees_link)                 { "Fees and payment" }
  let(:working_out_your_fee_link) { "Working out your fee" }
  let(:paying_your_fee_link)      { "Paying your issue fee" }
  let(:reducing_your_fee_link)    { "Reducing fees" }
  let(:writing_yours_link)        { "Writing your claim statement" }

  let(:time_limits_div)           { "#time_limits" }
  let(:acas_div)                  { "#acas_early_conciliation" }
  let(:acas_exceptions_div)       { "#acas_early_conciliation_exceptions" }
  let(:fees_div)                  { "#fees_and_payment" }
  let(:working_out_your_fee_div)  { "#fees_and_payment_working_out_your_fee" }
  let(:paying_your_fee_div)       { "#fees_and_payment_paying_your_fee" }
  let(:reducing_your_fee_div)     { "#reducing_fees" }
  let(:writing_yours_div)         { "#writing_your_claim_statement" }

  scenario "User can click time time_limits_link" do
    expect(page).to have_link(time_limits_link, href: "#{guide_path + time_limits_div}")
    expect(page.find(time_limits_div)).not_to be_nil
  end

  scenario "User can click time acas_link" do
    expect(page).to have_link(acas_link, href: "#{guide_path + acas_div}")
    expect(page.find(acas_div)).not_to be_nil
  end

  scenario "User can click time acas_exceptions_link" do
    expect(page).to have_link(acas_exceptions_link, href: "#{guide_path + acas_exceptions_div}")
    expect(page.find(acas_exceptions_div)).not_to be_nil
  end

  scenario "User can click time fees_link" do
    expect(page).to have_link(fees_link, href: "#{guide_path + fees_div}")
    expect(page.find(fees_div)).not_to be_nil
  end

  scenario "User can click time working_out_your_fee_link" do
    expect(page).to have_link(working_out_your_fee_link, href: "#{guide_path + working_out_your_fee_div}")
    expect(page.find(working_out_your_fee_div)).not_to be_nil
  end

  scenario "User can click time paying_your_fee_link" do
    expect(page).to have_link(paying_your_fee_link, href: "#{guide_path + paying_your_fee_div}")
    expect(page.find(paying_your_fee_div)).not_to be_nil
  end

  scenario "User can click time reducing_your_fee_link" do
    expect(page).to have_link(reducing_your_fee_link, href: "#{guide_path + reducing_your_fee_div}")
    expect(page.find(reducing_your_fee_div)).not_to be_nil
  end

  scenario "User can click time writing_yours_link" do
    expect(page).to have_link(writing_yours_link, href: "#{guide_path + writing_yours_div}")
    expect(page.find(writing_yours_div)).not_to be_nil
  end

end
