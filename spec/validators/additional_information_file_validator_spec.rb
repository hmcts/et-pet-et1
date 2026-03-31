require 'rails_helper'

class AdditionalInformationModelClass < ApplicationRecord
  establish_connection adapter: :nulldb,
                       schema: 'config/nulldb_schema.rb'

  attribute :example_file, :gds_azure_file

  validates :example_file,
            additional_information_file: true
end

RSpec.describe AdditionalInformationFileValidator do
  describe '#valid?' do
    let(:example_base_api_url) { 'http://et-api.com' }
    let(:example_translations) do
      {
        activerecord: {
          errors: {
            models: {
              additional_information_model_class: {
                attributes: {
                  example_file: {
                    password_protected: "This file is password protected. Upload a file that isn’t password protected."
                  }
                }
              }
            }
          }
        }
      }
    end

    around do |example|
      I18n.backend.store_translations I18n.locale, example_translations
      example.run
      I18n.backend.reload!
    end

    it 'adds API validation errors to the file attribute' do
      response_body = {
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
      stub_request(:post, "#{example_base_api_url}/validate").
        with(body: hash_including(command: 'ValidateAdditionalInformationFile')).
        to_return(status: 422, body: response_body.to_json, headers: { 'ContentType' => 'application/json' })
      model = AdditionalInformationModelClass.new(example_file: { filename: 'a.pdf', path: '/tmp/a.pdf',
                                                                  content_type: 'application/pdf' }.stringify_keys)

      ClimateControl.modify ET_API_URL: example_base_api_url do
        model.valid?
      end

      expect(model.errors[:example_file]).to include("This file is password protected. Upload a file that isn’t password protected.")
    end
  end
end
