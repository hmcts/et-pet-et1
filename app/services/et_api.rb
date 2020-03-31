class EtApi
  def self.create_claim(claim, uuid: SecureRandom.uuid, submit_claim_service: SubmitClaimToApiService)
    submit_claim_service.call(claim, uuid: uuid)
  end

  def self.build_diversity_response(diversity_response, uuid: SecureRandom.uuid, submit_diversity_response_service: SubmitDiversityResponseToApiService)
    submit_diversity_response_service.call(diversity_response, uuid: uuid)
  end
end
