require 'rails_helper'

feature 'Diversity' do

  before do
    visit diversities_path
  end

  scenario "I should be see intro page befor I fill the diversity form" do
    expect(page).to have_text "Diversity monitoring questionnaire"
    expect(page).to have_text "This is optional and won't affect your claim."
    expect(page).to have_text "Your answers will be anonymous. "
  end

  scenario "I can fill the diversity form" do
    expect(page).to have_text "Diversity monitoring questionnaire"
    click_link "Begin this form"

    fill_the_questionaire

    click_button "Next"

    claim_type = find(:xpath, ".//table//tr[1]").text
    sex = find(:xpath, ".//table//tr[2]").text
    identity = find(:xpath, ".//table//tr[3]").text
    age = find(:xpath, ".//table//tr[4]").text
    ethnicity = find(:xpath, ".//table//tr[5]").text
    ethnicity_sugroup = find(:xpath, ".//table//tr[6]").text
    disability = find(:xpath, ".//table//tr[7]").text
    caring = find(:xpath, ".//table//tr[8]").text
    gender = find(:xpath, ".//table//tr[9]").text
    gender_birth = find(:xpath, ".//table//tr[10]").text
    pregnancy = find(:xpath, ".//table//tr[11]").text
    relationship = find(:xpath, ".//table//tr[12]").text
    religion = find(:xpath, ".//table//tr[13]").text

    expect(claim_type).to eql "Please confirm your type of claim to help us analyse other information provided in this form.Discrimination"
    expect(sex).to eql "What is your sex?Male"
    expect(identity).to eql "Which of the options below best describes your sexual identity?Other"
    expect(age).to eql "Which age group are you in?25-34"
    expect(ethnicity).to eql "What is your ethnic group?White"
    expect(ethnicity_sugroup).to eql "What type is your ethnic group?Irish"
    expect(disability).to eql "Do you have any physical or mental health conditions or illnesses lasting or expected to last for 12 months or more?No"
    expect(caring).to eql "Do you have any caring responsibilities (eg, children, elderly relatives, partners etc)?No"
    expect(gender).to eql "Please select your gender identity.Male (including female-to-male trans men)"
    expect(gender_birth).to eql "Is your gender identity different to the sex you were assumed to be at birth?Yes"
    expect(pregnancy).to eql "Were you pregnant when you were dismissed?No"
    expect(relationship).to eql "Please describe your relationship status.Married"
    expect(religion).to eql "What is your religion?Hindu"

    click_link "Submit Form"
    expect(page).to have_text "Thank you for completing this diversity monitoring questionnaire."
  end


  scenario "I can edit my responses" do
    expect(page).to have_text "Diversity monitoring questionnaire"
    click_link "Begin this form"

    fill_the_questionaire
    click_button "Next"

    expect(page).to have_text "Confirmation of supplied details"

    sex = find(:xpath,".//table/tr[2]").text
    expect(sex).to eql('What is your sex?Male')

    click_link "Edit your answers"

    select "Female", from: 'diversity_sex'
    click_button "Next"

    expect(page).to have_text "Confirmation of supplied details"
    sex = find(:xpath,".//table/tr[2]").text
    expect(sex).to eql('What is your sex?Female')
  end


  def fill_the_questionaire
    select "Discrimination", from: 'diversity_claim_type'
    select "Male", from: 'diversity_sex'
    select "Other", from: 'diversity_sexual_identity'
    select "Male (including female-to-male trans men)", from: 'diversity_gender'
    select "Yes", from: 'diversity_gender_at_birth'

    select "White", from: 'diversity_ethnicity'
    within(:xpath, './/fieldset[@data-name="White"]') do
      select "Irish", from: 'White (optional)'
    end

    select "25-34", from: 'diversity_age_group'
    select "Married", from: 'diversity_relationship'
    select "Hindu", from: 'diversity_religion'
    select "No", from: 'diversity_caring_responsibility'
    select "No", from: 'diversity_pregnancy'
    select "No", from: 'diversity_disability'
  end
end
