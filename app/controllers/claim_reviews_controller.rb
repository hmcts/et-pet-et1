class ClaimReviewsController < ApplicationController
  redispatch_request unless: :created?
  before_action :check_session_expiry
  helper_method :null_object

  def update
    claim.update confirmation_email_recipients: email_addresses
    response = EtApi.create_claim(claim)
    if response.valid?
      claim.update state: 'submitted',
                   pdf_url: response.response_data.dig('meta', 'BuildClaim', 'pdf_url'),
                   fee_group_reference: response.response_data.dig('meta', 'BuildClaim', 'reference')
      claim.create_office! response.response_data.dig('meta', 'BuildClaim', 'office').slice('code', 'name', 'address',
                                                                                            'telephone', 'email')
      redirect_to claim_confirmation_path
    else
      claim.update state: 'submission_failed'
      raise "An error occured in the API - #{response.errors.full_messages}"
    end
  end

  def show
    render locals: {
      claim:,
      primary_claimant: claim.primary_claimant || null_object,
      representative: claim.representative || null_object,
      employment: claim.employment || null_object,
      respondent: claim.primary_respondent || null_object,
      secondary_claimants: claim.secondary_claimants,
      secondary_respondents: claim.secondary_respondents
    }
  end

  private

  def load_claim_from_session
    return nil if session[:claim_reference].blank?

    Claim.includes(secondary_respondents: :addresses,
                   secondary_claimants: :address).find_by(application_reference: session[:claim_reference])
  end

  def null_object
    @null_object ||= NullObject.new
  end

  def email_addresses
    params[:confirmation_email][:email_addresses].reject(&:blank?)
  end
end
