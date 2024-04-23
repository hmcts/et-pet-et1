json.uuid SecureRandom.uuid
json.command 'BuildPrimaryClaimant'
json.data do
  json.partial! 'api/claim/primary_claimant_attributes', claimant:
end
