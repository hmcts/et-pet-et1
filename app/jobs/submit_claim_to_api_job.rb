class SubmitClaimToApiJob < ApplicationJob
  queue_as :default

  retry_on ApiService::InternalServerError, wait: 5.minutes, attempts: 25
  retry_on ApiService::UnknownResponse, wait: 5.minutes, attempts: 25
  retry_on ApiService::Timeout, wait: 5.minutes, attempts: 25

  def perform(claim)
    Rails.logger.info "Submitting claim #{claim.application_reference} to API in background"

    begin
      response = EtApi.create_claim(claim)
      claim.update! state: 'submitted',
                    pdf_url: response.response_data.dig('meta', 'BuildClaim', 'pdf_url'),
                    fee_group_reference: response.response_data.dig('meta', 'BuildClaim', 'reference')

      create_office(claim, response)
      Rails.logger.info "Successfully submitted claim #{claim.application_reference} to API"
    rescue ApiService::BaseException => e
      # This will be retried by ActiveJob for retryable exceptions
      # ValidationError and BadRequest will be discarded/not retried due to configuration above
      Rails.logger.warn "Error submitting claim #{claim.application_reference}: #{e.message}"
      raise e
    end
  end

  def after_retry_exhausted(error)
    claim = arguments.first
    claim.update!(state: 'submission_failed') if claim
    Rails.logger.error "Exhausted all retries for claim #{claim&.application_reference}: #{error.message}"
    Sentry.capture_exception(error) if defined?(Sentry)
  end

  private

  def create_office(claim, response)
    office_data = response.response_data.dig('meta', 'BuildClaim', 'office')
    return unless office_data

    claim.create_office!(office_data.slice('code', 'name', 'address', 'telephone', 'email'))
  end
end
