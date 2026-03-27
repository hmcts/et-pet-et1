# frozen_string_literal: true

json.uuid uuid
json.command 'ValidateAdditionalInformationFile'
json.data do
  json.filename file['filename']
  json.checksum nil
  json.data_from_key file['path']
  json.data_url nil
end
