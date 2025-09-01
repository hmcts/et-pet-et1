class SubmitClaimToApiService < ApiService
  def self.call(*args, **kw_args)
    new.call(*args, **kw_args)
  end

  def call(claim, uuid: SecureRandom.uuid)
    # Set submitted_at for data purposes but don't change state yet
    claim.submitted_at ||= Time.now.utc
    json = ApplicationController.render 'api/claim/create_claim', format: :json, locals: {
      claim:, employment: claim.employment, uuid:
    }
    send_request(json, path: '/claims/build_claim', subject: 'claim')

    # Only mark as submitted after successful API call
    claim.update state: 'submitted'
    self
  end

end
