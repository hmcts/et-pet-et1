json.uuid SecureRandom.uuid
json.command 'BuildClaimDetailsFile'
json.data do
  json.filename FilenameCleaner.for(file, underscore: true)
  json.checksum nil
  json.data_url nil
  json.data_from_key file['path']
end
