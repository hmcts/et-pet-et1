require 'rails_helper'

RSpec.describe AdditionalClaimantsCsvValidator do
  class ModelClass < ApplicationRecord
    establish_connection adapter: :nulldb,
                         schema: 'config/nulldb_schema.rb'

    attribute :example_csv, :gds_azure_file
    attribute :example_csv_record_count

    validates :example_csv,
              additional_claimants_csv: true
  end
  describe '#valid?' do
    let(:example_base_api_url) { 'http://et-api.com' }
    let(:example_translations) do
      {
        activemodel: {
          errors: {
            models: {
              model_class: {
                attributes: {
                  example_csv_row: {
                    row_prefix: 'Row %<line_number>s',
                    attributes: {
                      title: { inclusion: 'The value "%<value>s" is not in the list' },
                      date_of_birth: { invalid: 'The date is invalid' },
                      street: { too_long: 'The street value is greater than the maximum %<count>s' },
                      locality: { too_long: 'The locality value is greater than the maximum %<count>s' },
                      post_code: { invalid: 'The post code is invalid' }
                    }
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

    it 'translates errors from API' do
      response_body = {
        "status": "not_accepted",
        "uuid": "fbad7ec7-2da7-4e34-9509-d73c5e20ec72",
        "errors": [
          {
            "status": 422,
            "code": "invalid",
            "title": "is invalid",
            "detail": "is invalid",
            "options": {},
            "source": "/data_from_key/0/date_of_birth",
            "command": "ValidateClaimantsFile",
            "uuid": "fbad7ec7-2da7-4e34-9509-d73c5e20ec72"
          },
          {
            "status": 422,
            "code": "inclusion",
            "title": "is not included in the list",
            "detail": "is not included in the list",
            "options": {
              "value": "Dr"
            },
            "source": "/data_from_key/1/title",
            "command": "ValidateClaimantsFile",
            "uuid": "fbad7ec7-2da7-4e34-9509-d73c5e20ec72"
          },
          {
            "status": 422,
            "code": "too_long",
            "title": "is too long (maximum is 50 characters)",
            "detail": "is too long (maximum is 50 characters)",
            "options": {
              "count": 50
            },
            "source": "/data_from_key/2/street",
            "command": "ValidateClaimantsFile",
            "uuid": "fbad7ec7-2da7-4e34-9509-d73c5e20ec72"
          },
          {
            "status": 422,
            "code": "too_long",
            "title": "is too long (maximum is 50 characters)",
            "detail": "is too long (maximum is 50 characters)",
            "options": {
              "count": 50
            },
            "source": "/data_from_key/3/locality",
            "command": "ValidateClaimantsFile",
            "uuid": "fbad7ec7-2da7-4e34-9509-d73c5e20ec72"
          },
          {
            "status": 422,
            "code": "invalid",
            "title": "is invalid",
            "detail": "is invalid",
            "options": {},
            "source": "/data_from_key/5/post_code",
            "command": "ValidateClaimantsFile",
            "uuid": "fbad7ec7-2da7-4e34-9509-d73c5e20ec72"
          }
        ]
      }
      stub_request(:post, "#{example_base_api_url}/validate").
        with(body: hash_including(command: 'ValidateClaimantsFile')).
        to_return(status: 422, body: response_body.to_json, headers: { 'ContentType' => 'application/json' })
      model = ModelClass.new(example_csv: { filename: 'a.txt', path: '/tmp/a.txt', content_type: 'text/csv' }.stringify_keys)

      ClimateControl.modify ET_API_URL: example_base_api_url do
        model.valid?
      end
      expect(model.errors.details[:example_csv]).to include error: :invalid,
                                                            line_errors: containing_exactly(
                                                              'Row 1 The date is invalid',
                                                              'Row 2 The value "Dr" is not in the list',
                                                              'Row 3 The street value is greater than the maximum 50',
                                                              'Row 4 The locality value is greater than the maximum 50',
                                                              'Row 6 The post code is invalid'
                                                            )
    end
  end
end
