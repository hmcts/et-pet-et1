json.uuid SecureRandom.uuid
json.command 'BuildPrimaryRespondent'
json.data do
  json.partial! 'api/claim/respondent_attributes', respondent:
end
