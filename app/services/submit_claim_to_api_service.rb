class SubmitClaimToApiService < ApiService
  def self.call(*args, **kw_args)
    new.call(*args, **kw_args)
  end

  def call(claim, uuid: SecureRandom.uuid)
    claim.submitted_at ||= Time.now.utc
    claim.update state: 'submitted'
    json = ApplicationController.render 'api/claim/create_claim', format: :json, locals: {
      claim:, employment: claim.employment, uuid:
    }
    send_request(json, path: '/claims/build_claim', subject: 'claim')
    self
  end

  private

  def generate_custom_errors
    response_data['errors'].each do |error|
      attr = error_attribute_for(error)
      errors.add(attr, error['detail'])
    end
  end

  # rubocop:disable Metrics/MethodLength
  def error_attribute_for(error)
    attr = error['source'].split('/').last
    case error['command']
    when 'BuildClaim'
      :"claim.#{attr}"
    when 'BuildPrimaryClaimant'
      :"claim.primary_claimant.#{attr}"
    when 'BuildSecondaryClaimants'
      :"claim.secondary_claimants.#{attr}"
    when 'BuildPrimaryRespondent'
      :"claim.primary_respondent.#{attr}"
    when 'BuildSecondaryRespondents'
      :"claim.secondary_respondents.#{attr}"
    else
      :base
    end
  end
  # rubocop:enable Metrics/MethodLength
end
