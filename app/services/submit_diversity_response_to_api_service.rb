class SubmitDiversityResponseToApiService < ApiService
  def self.call(*args, **kw_args)
    new.call(*args, **kw_args)
  end

  def call(diversity_response, uuid: SecureRandom.uuid)
    json = ApplicationController.render 'api/diversity/build_diversity_response', format: :json, locals: {
      response: diversity_response, uuid:
    }
    send_request(json, path: '/diversity/build_diversity_response', subject: 'diversity_response')
  end

  private

  def generate_custom_errors
    response_data['errors'].each do |error|
      attr = error_attribute_for(error)
      errors.add(attr, error['detail'])
    end
  end

  def error_attribute_for(error)
    :"diversity_response.#{error['source'].split('/').last}"
  end
end
