json.uuid SecureRandom.uuid
json.command 'CreateReference'
json.data do
  json.post_code address.post_code
end
