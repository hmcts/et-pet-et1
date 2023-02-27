# frozen_string_literal: true

json.uuid uuid
json.command 'ValidateClaimantsFile'
json.data do
  json.filename File.basename(file['filename'], '.*').
    gsub(/[^a-zA-Z0-9]/, '_').
    concat(File.extname(file['filename']))
  json.checksum nil
  json.data_url nil
  json.data_from_key file['path']
end
