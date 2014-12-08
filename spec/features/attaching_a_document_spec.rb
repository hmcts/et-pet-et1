require 'rails_helper'

feature 'Attaching a document' do
  include FormMethods
  include Messages

  let(:claim) { Claim.create password: 'lollolol' }
  let(:file_path) { Pathname.new(Rails.root) + 'spec/support/files/file.rtf' }
  let(:alternative_file_path) { file_path + '../alt_file.rtf' }
  let(:image_file_path) { file_path + '../phil.jpg' }

  def upload_file!
    visit '/apply/additional-information'
    attach_file "additional_information_additional_information_rtf", file_path
    click_button 'Save and continue'
  end

  before do
    visit returning_user_session_path
    fill_in_return_form claim.reference, 'lollolol'
  end

  scenario 'Attaching a file' do
    upload_file!
    expect(claim.reload.additional_information_rtf_file.read).to eq File.read(file_path)
  end

  scenario 'Deleting a file' do
    upload_file!

    visit '/apply/additional-information'

    check "additional_information_remove_additional_information_rtf"

    click_button 'Save and continue'

    expect(claim.reload.additional_information_rtf.present?).to be false
  end

  scenario 'Replacing a file' do
    upload_file!

    visit '/apply/additional-information'

    attach_file "additional_information_additional_information_rtf", alternative_file_path
    click_button 'Save and continue'

    expect(claim.reload.additional_information_rtf_file.read).to eq File.read(alternative_file_path)
  end

  scenario 'Uploading a non text file' do
    visit '/apply/additional-information'

    attach_file "additional_information_additional_information_rtf", image_file_path
    click_button 'Save and continue'

    expect(page).to have_text('is not an RTF or plain text file')
    expect(claim.additional_information_rtf).not_to be_present
  end
end
