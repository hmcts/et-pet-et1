class ValidateAdditionalInformationFileViaApiService < ApiService
  def self.call(*args, **kw_args)
    new.call(*args, **kw_args)
  end

  def call(record, attribute, value, uuid: SecureRandom.uuid)
    @record = record
    @attribute = attribute
    json = ApplicationController.render 'api/claim/validate_additional_information_file', format: :json, locals: {
      file: value, uuid:
    }
    send_request(json, path: '/validate', subject: 'additional information file')
    self
  end

  def generate_errors
    return unless response.code == 422

    if response_data['status'] == 'not_accepted'
      generate_custom_errors
    else
      errors.add :base, :unknown_422_error_from_api
    end
  end

  def generate_custom_errors
    response_data['errors'].each do |error|
      options = (error['options'] || {}).deep_symbolize_keys
      source = error['source'] == '/' ? :base : error['source']
      errors.add(source, error['code'], **options)
    end
  end
end
