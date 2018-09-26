require 'rails_helper'

RSpec.feature 'Switching language', type: :feature do

  scenario 'hitting the stats end point returns json' do
    visit root_path
    expect(page).to have_link("Cymraeg", href: '/apply?locale=cy')
    expect(page).to have_text("Make a claim to an employment tribunal")
    click_link('Cymraeg')

    expect(page).to have_link("English", href: '/apply?locale=en')
    expect(page).to have_text("Gwneud hawliad i dribiwnlys cyflogaeth")

    click_link('English')
    expect(page).to have_text("Make a claim to an employment tribunal")
    expect(page).to have_link("Cymraeg", href: '/apply?locale=cy')
  end

  scenario 'langauge should persist after submitting the form' do
    visit root_path
    click_button 'Start a claim'

    expect(page).to have_text('Saving your claim')
    click_link('Cymraeg')

    expect(page).to have_text('Cadw eich hawliad')
    click_button('Cadw a pharhau')
    expect(page).to have_text('Mae gwallau ar y dudalen')
    expect(page).to have_text("Dylech greu gair cofiadwy er mwyn i chi allu dychwelyd i'ch hawliad")
  end
end
