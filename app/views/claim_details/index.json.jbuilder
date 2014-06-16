json.array!(@claim_details) do |claim_detail|
  json.extract! claim_detail, :id, :unfairly_dismissed, :discrimination, :pay, :whistleblowing_claim, :type_of_claims, :other_complaints, :want_if_claim_successful, :compensation_other_outcome, :similar_claims, :similar_claims_names, :additional_information, :rtf_file
  json.url claim_detail_url(claim_detail, format: :json)
end
