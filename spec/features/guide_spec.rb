require 'rails_helper'

feature 'Guide' do
  
  let(:fees_header)           { "<h1>Fees</h1>" }
  let(:acas_header)           { "<h1>Acas: early conciliation</h1>" }
  let(:writing_yours_header)  { "<h1>Writing your claim statement</h1>" }

  before :each do 
    visit guide_path
  end
  
  scenario "User visits the guides page" do
    expect(page.html).to include(fees_header)
    expect(page.html).to include(acas_header)
    expect(page.html).to include(writing_yours_header)
  end

  let(:fees_link)           { "Fees" }
  let(:acas_link)           { "Acas: early conciliation" }
  let(:writing_yours_link)  { "Writing your claim statement" }

  let(:fees_div)           { "#fees" }
  let(:acas_div)           { "#acas_early_conciliation" }
  let(:writing_yours_div)  { "#writing_your_claim_statement" }

  scenario "User can click fees link" do
    expect(page).to have_link(fees_link, href: "#{guide_path + fees_div}")
    expect(page.find(fees_div)).not_to be_nil
  end

  scenario "User can click acas_early_conciliation link" do
    expect(page).to have_link(acas_link, href: "#{guide_path + acas_div}")
    expect(page.find(acas_div)).not_to be_nil
  end

  scenario "User can click writing_your_claim_statmen link" do
    expect(page).to have_link(writing_yours_link, href: "#{guide_path + writing_yours_div}")
    expect(page.find(writing_yours_div)).not_to be_nil
  end

end