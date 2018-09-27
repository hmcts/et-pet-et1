json.uuid SecureRandom.uuid
json.command 'BuildPrimaryClaimant'
json.data do
  json.partial! 'api/claim/claimant_attributes', claimant: claimant
end
