class ValidateClaimantsFileViaApiService < ApiService
  attr_reader :line_count

  def self.call(*args, **kw_args)
    new.call(*args, **kw_args)
  end

  def call(record, attribute, value, uuid: SecureRandom.uuid)
    @record = record
    @attribute = attribute
    json = ApplicationController.render 'api/claim/validate_claimants_file', format: :json, locals: {
      file: value, uuid: uuid
    }
    send_request(json, path: '/validate', subject: 'claimants file')
    @line_count = response_data.dig('meta', 'line_count')
    self
  end

  def generate_custom_errors
    response_data['errors'].each do |error|
      source = error['source'] == '/' ? :base : error['source']
      options = (error['options'] || {}).deep_symbolize_keys
      errors.add(source, error['code'], **options)
    end
  end
end
