require 'rails_helper'

RSpec.describe ClaimDetailsForm, type: :form do
  let(:claim_details_form) { described_class.new Claim.new }
  let(:example_base_api_url) { 'http://et-api.com' }
  let(:password_protected_message) { "This file is password protected. Upload a file that isn’t password protected." }

  around do |example|
    I18n.backend.store_translations I18n.locale, example_translations
    ClimateControl.modify ET_API_URL: example_base_api_url do
      example.run
    end
    I18n.backend.reload!
  end

  before do
    stub_request(:post, "#{example_base_api_url}/validate").
      with(body: hash_including(command: 'ValidateAdditionalInformationFile')).
      to_return(status: 200, body: { status: 'accepted', uuid: SecureRandom.uuid, errors: [] }.to_json,
                headers: { 'ContentType' => 'application/json' })
  end

  def example_translations
    {
      activemodel: {
        errors: {
          models: {
            claim_details_form: {
              attributes: {
                claim_details_rtf: {
                  password_protected: password_protected_message
                }
              }
            }
          }
        }
      }
    }
  end

  describe 'validations' do
    context 'with presence' do
      it { expect(claim_details_form).to validate_presence_of(:claim_details) }

      context 'when claim details attached as an RTF' do
        before { claim_details_form.claim_details_rtf = { 'path' => 'anything', 'content_type' => 'application/rtf', 'filename' => 'filename.rtf' } }

        it { expect(claim_details_form).not_to validate_presence_of(:claim_details) }
      end
    end

    context 'with character lengths' do
      before { claim_details_form.other_known_claimants = true }

      it { expect(claim_details_form).to validate_length_of(:claim_details).is_at_most(2500) }
      it { expect(claim_details_form).to validate_length_of(:other_known_claimant_names).is_at_most(350) }
    end
  end

  describe 'on #claim_details_rtf' do
    let(:path) { Rails.root.join('spec/support/files').to_s }

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

    context 'when the filename extension is disallowed but the mime type matches an allowed legacy Office format' do
      let(:file) { { 'path' => "#{path}/file.xla", 'filename' => 'file.xla', 'content_type' => 'application/vnd.ms-excel' } }

      it 'adds an error message to the attribute' do
        expect(claim_details_form.errors[:claim_details_rtf]).to include(I18n.t('errors.messages.rtf'))
      end
    end

    context 'when the api rejects the uploaded file' do
      let(:file) { { 'path' => "#{path}/file.pdf", 'filename' => 'file.pdf', 'content_type' => 'application/pdf' } }

      before do
        stub_request(:post, "#{example_base_api_url}/validate").
          with(body: hash_including(command: 'ValidateAdditionalInformationFile')).
          to_return(status: 422, body: api_rejection_response.to_json, headers: { 'ContentType' => 'application/json' })

        claim_details_form.claim_details_rtf = file
        claim_details_form.valid?
      end

      it 'adds the api error to the attribute' do
        expect(claim_details_form.errors[:claim_details_rtf]).to include(password_protected_message)
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

  def api_rejection_response
    {
      status: "not_accepted",
      uuid: "fbad7ec7-2da7-4e34-9509-d73c5e20ec72",
      errors: [
        {
          status: 422,
          code: "password_protected",
          title: "This file is password protected. Upload a file that isn't password protected.",
          detail: "This file is password protected. Upload a file that isn't password protected.",
          options: {},
          source: "/data_from_key",
          command: "ValidateAdditionalInformationFile",
          uuid: "fbad7ec7-2da7-4e34-9509-d73c5e20ec72"
        }
      ]
    }
  end
end
