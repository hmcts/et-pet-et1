class SubmitClaimToApiService < ApiService
  def self.call(*args)
    new.call(*args)
  end

  def call(claim, uuid: SecureRandom.uuid)
    claim.update submitted_at: Time.now.utc, state: 'submitted'
    json = ApplicationController.render 'api/claim/create_claim.json.jbuilder', locals: {
      claim: claim, employment: claim.employment, uuid: uuid
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

  def error_attribute_for(error)
    attr = error['source'].split('/').last
    case error['command']
    when 'BuildClaim' then
      :"claim.#{attr}"
    when 'BuildPrimaryClaimant' then
      :"claim.primary_claimant.#{attr}"
    when 'BuildSecondaryClaimants' then
      :"claim.secondary_claimants.#{attr}"
    when 'BuildPrimaryRespondent' then
      :"claim.primary_respondent.#{attr}"
    when 'BuildSecondaryRespondents' then
      :"claim.secondary_respondents.#{attr}"
    else
      :base
    end
  end
end
