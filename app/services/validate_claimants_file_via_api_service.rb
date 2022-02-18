class ValidateClaimantsFileViaApiService < ApiService
  def self.call(*args)
    new.call(*args)
  end

  def call(record, attribute, value, uuid: SecureRandom.uuid)
    json = ApplicationController.render 'api/claim/validate_claimants_file.json.jbuilder', locals: {
      file: value, uuid: uuid
    }
    send_request(json, path: '/validate', subject: 'claimants file')
    self
  end

  def generate_custom_errors
    debug_me = true
  end
end
