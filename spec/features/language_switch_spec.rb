require 'rails_helper'

RSpec.describe 'Switching language', type: :feature do

  it 'hitting the stats end point returns json' do
    visit root_path
    expect(page).to have_link("Cymraeg", href: '/cy/apply')
    expect(page).to have_text("Make a claim to an employment tribunal")
    click_link_or_button('Cymraeg')

    expect(page).to have_link("English", href: '/en/apply')
    expect(page).to have_text("Gwneud hawliad i dribiwnlys cyflogaeth")

    click_link_or_button('English')
    expect(page).to have_text("Make a claim to an employment tribunal")
    expect(page).to have_link("Cymraeg", href: '/cy/apply')
  end

  it 'langauge should persist after submitting the form', :js do
    visit root_path
    click_link_or_button 'Start a claim'

    expect(page).to have_text('Saving your claim')
    expect(page).to have_current_path('/en/apply/application-number')
    click_link_or_button('Cymraeg')

    expect(page).to have_text('Cadw eich hawliad')
    expect(page).to have_current_path('/cy/apply/application-number')
    click_link_or_button('Cadw a pharhau')

    expect(page).to have_text("Rhowch wybodaeth yn y blychau testun sydd wedi'u hamlygu.")
    expect(page).to have_text("Dylech greu gair cofiadwy er mwyn i chi allu dychwelyd i'ch hawliad")
    expect(page).to have_text('Cadw eich hawliad')
  end
end
