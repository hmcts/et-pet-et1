json.uuid SecureRandom.uuid
json.command 'BuildClaimDetailsFile'
json.data do
  json.filename CarrierwaveFilename.for(file, underscore: true)
  json.checksum nil
  json.data_url file.url
  json.data_from_key nil
end

