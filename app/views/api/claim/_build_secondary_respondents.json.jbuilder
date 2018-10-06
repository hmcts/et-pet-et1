json.uuid SecureRandom.uuid
json.command 'BuildSecondaryRespondents'
json.data do
  json.partial! 'api/claim/respondent_attributes', collection: respondents, as: :respondent
end
