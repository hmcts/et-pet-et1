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
end
