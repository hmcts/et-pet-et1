require 'rails_helper'

feature 'Multiple claimants CSV' do
  include FormMethods

  let(:claim) { Claim.create password: 'lollolol' }

  before do
    visit new_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  describe 'adding claimants' do
    before do
      visit claim_additional_claimants_upload_path
      choose 'Yes'
    end

    context "group claimants age has to be 16 or over" do
      let(:csv_line) { ["Mr", "Tom", "Test", "01/01/2016", "1", "Test", "London", "Great London", "N103QS"] }

      scenario "if claimant is too young" do
        upload_group_claim_file
        click_button "Save and continue"

        expect(page).to have_text("An error has been found on line 2 of the uploaded file.")
        expect(page).to have_text("Date of birth - Claimant must be 16 years of age or over")
      end

      context 'dob is missing' do
        let(:csv_line) { ["Mr", "Tom", "Test", "", "1", "Test", "London", "Great London", "N103QS"] }
        scenario "error is displayed" do
          upload_group_claim_file
          click_button "Save and continue"

          expect(page).to have_text("An error has been found on line 2 of the uploaded file.")
          expect(page).to have_text("Date of birth - Claimant must be 16 years of age or over")
        end
      end

      context "incorrect format" do
        let(:csv_line) { ["Mr", "Tom", "Test", "15-12-74", "1", "Test", "London", "Great London", "N103QS"] }

        scenario "with dashes" do
          upload_group_claim_file
          click_button "Save and continue"
          expect(page).to have_text("For dates of birth, use numbers and/or letters separated by forward slashes. Eg 23/04/1983 or 23/Apr/1983")
        end
      end

      context "Allow month names" do
        let(:csv_line) { ["Mr", "Tom", "Test", "15/Dec/74", "1", "Test", "London", "Great London", "N103QS"] }

        scenario "as text" do
          upload_group_claim_file
          click_button "Save and continue"
          expect(page).not_to have_text("For dates of birth, use numbers and/or letters separated by forward slashes. Eg 23/04/1983 or 23/Apr/1983")
        end
      end

      context 'all data are ok' do
        let(:csv_line) { ["Mr", "Tom", "Test", "01/01/1990", "1", "Test", "London", "Great London", "N103QS"] }
        scenario "no error displayed" do
          upload_group_claim_file
          click_button "Save and continue"

          expect(page).not_to have_text("An error has been found")
          expect(page).not_to have_text("Date of birth - Claimant must be 16 years of age or over")
        end
      end
    end
  end

  def upload_group_claim_file
    csv_string = CSV.generate do |csv|
      csv << ["Title", "First name", "Last name", "Date of birth", "Building number or name", "Street", "Town/city", "County", "Postcode"]
      csv << csv_line
    end
    file = Tempfile.new('test')
    file.write(csv_string)
    attach_file('additional_claimants_upload_additional_claimants_csv', file.path)
    file.close
  end
end
