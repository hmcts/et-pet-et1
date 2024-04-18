require 'rails_helper'

RSpec.describe ClaimDetailsForm, type: :form do
  let(:claim_details_form) { described_class.new Claim.new }

  describe 'validations' do
    context 'presence' do
      it { expect(claim_details_form).to validate_presence_of(:claim_details) }

      context 'claim details attached as an RTF' do
        before { claim_details_form.claim_details_rtf = { 'path' => 'anything', 'content_type' => 'application/rtf', 'filename' => 'filename.rtf' } }

        it { expect(claim_details_form).not_to validate_presence_of(:claim_details) }
      end
    end

    context 'character lengths' do
      before { claim_details_form.other_known_claimants = true }

      it { expect(claim_details_form).to validate_length_of(:claim_details).is_at_most(2500) }
      it { expect(claim_details_form).to validate_length_of(:other_known_claimant_names).is_at_most(350) }
    end
  end

  describe 'on #claim_details_rtf' do
    let(:path) { "#{Rails.root}/spec/support/files" }

    before do
      claim_details_form.claim_details_rtf = file
      claim_details_form.valid?
    end

    context 'when its value is a plain text file' do
      let(:file) { File.open("#{path}/file.rtf") }

      it 'does nothing' do
        expect(claim_details_form.errors[:claim_details_rtf]).to be_empty
      end
    end

    context 'when its value is not a plain text file' do
      let(:file) { { 'path' => "#{path}phil.jpg", 'filename' => 'phil.jpg', 'content_type' => 'image/jpg' } }

      it 'adds an error message to the attribute' do
        expect(claim_details_form.errors[:claim_details_rtf]).to include(I18n.t('errors.messages.rtf'))
      end
    end
  end

  describe '#other_known_claimants' do
    context 'when #other_known_claimants is blank' do
      it 'is nil' do
        expect(claim_details_form.other_known_claimants).to be_nil
      end
    end

    context 'when #other_known_claimant_names is not blank' do
      before { claim_details_form.other_known_claimants = true }

      it 'is true' do
        expect(claim_details_form.other_known_claimants).to be true
      end
    end
  end

  describe '#other_known_claimant_names' do
    context 'when #other_known_claimant is false' do
      it 'does not have a value after validation' do
        claim_details_form.other_known_claimant_names = 'value'
        claim_details_form.other_known_claimants = false
        claim_details_form.valid?
        expect(claim_details_form.other_known_claimant_names).to be_nil
      end
    end
  end

  it_behaves_like "a Form",
                  claim_details: "I want to make a claim", other_known_claimants: 'true',
                  other_known_claimant_names: "Edgar"

end
