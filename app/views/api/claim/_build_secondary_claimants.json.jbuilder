json.uuid SecureRandom.uuid
json.command 'BuildSecondaryClaimants'
json.data do
  json.partial! 'api/claim/claimant_attributes', collection: claimants, as: :claimant
end
