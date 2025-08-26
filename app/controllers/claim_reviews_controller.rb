class ClaimReviewsController < ApplicationController
  redispatch_request unless: :created?, except: :in_progress
  before_action :check_session_expiry
  helper_method :null_object

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

  def update
    claim.update confirmation_email_recipients: email_addresses

    begin
      response = EtApi.create_claim(claim)
      claim_update(response)
      create_office(response)
      redirect_to claim_confirmation_path
    rescue ApiService::BaseException => e
      if e.retry?
        # Server errors, network issues, and other recoverable errors should retry
        claim.update! state: 'enqueued_for_submission'
        SubmitClaimToApiJob.perform_later(claim)
        redirect_to action: :in_progress
      else
        # Non-recoverable errors (validation errors, client errors) should not retry
        claim.update! state: 'submission_failed'
        raise "An error occured in the API - #{e.message}"
      end
    end
  end

  def in_progress
    redirect_to claim_confirmation_path if claim.submitted?
  end

  private

  def claim_update(response)
    claim.update state: 'submitted',
                 pdf_url: response.response_data.dig('meta', 'BuildClaim', 'pdf_url'),
                 fee_group_reference: response.response_data.dig('meta', 'BuildClaim', 'reference')
  end

  def create_office(response)
    claim.create_office! response.response_data.dig('meta', 'BuildClaim', 'office').slice('code', 'name', 'address',
                                                                                          'telephone', 'email')
  end

  def load_claim_from_session
    return nil if session[:claim_reference].blank?

    Claim.includes(secondary_respondents: :addresses,
                   secondary_claimants: :address).find_by(application_reference: session[:claim_reference])
  end

  def null_object
    @null_object ||= NullObject.new
  end

  def email_addresses
    params[:confirmation_email][:email_addresses].compact_blank
  end
end
