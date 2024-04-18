# frozen_string_literal: true

json.uuid uuid
json.command 'SerialSequence'
json.data do
  json.child! do
    json.partial! 'api/claim/build_claim', claim:, employment:
  end
  json.child! do
    json.partial! 'api/claim/build_primary_claimant', claimant: claim.primary_claimant
  end
  json.child! do
    json.partial! 'api/claim/build_primary_respondent', respondent: claim.primary_respondent
  end
  if claim.representative.present?
    json.child! do
      json.partial! 'api/claim/build_primary_representative', representative: claim.representative
    end
  end
  if claim.secondary_claimants.present?
    json.child! do
      json.partial! 'api/claim/build_secondary_claimants', claimants: claim.secondary_claimants
    end
  end
  if claim.secondary_respondents.present?
    json.child! do
      json.partial! 'api/claim/build_secondary_respondents', respondents: claim.secondary_respondents
    end
  end
  if claim.additional_claimants_csv.present?
    json.child! do
      json.partial! 'api/claim/build_claimants_file', file: claim.additional_claimants_csv
    end
  end
  if claim.claim_details_rtf.present?
    json.child! do
      json.partial! 'api/claim/build_claim_details_file', file: claim.claim_details_rtf
    end
  end
end
