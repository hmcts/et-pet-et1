require 'yaml'
require 'json'

input_filename, map_filename, new_keyvault_name = ARGV.first(3)
puts "Input filename is #{input_filename}"
puts "Map filename is #{map_filename}"
puts "New keyvault name is #{new_keyvault_name}"

map = YAML.load_file(map_filename)

yaml = YAML.load_file(input_filename)
key_vaults = []
yaml['env'].each_pair do |key, value|
  if value.to_s =~ /<azure-secret:(.*)>/
    result_json = `az keyvault secret show --name #{Regexp.last_match(1)} --subscription 58a2ce36-4e09-467b-8330-d164aa559c68 --vault-name f74dd7b303a6devops`
    result = JSON.parse(result_json)
    new_key = map['env'][key]
    value = result['value']
    if new_key
      cmd = "az keyvault secret set --name #{new_key} --subscription 1c4f0704-a29e-403d-b719-b90c34ef14c9 --vault-name #{new_keyvault_name} --value \"#{value}\""
      result_json = `#{cmd}`
      result = JSON.parse(result_json)
      if result['name'] != new_key || result['value'] != value
        raise "Error writing secret #{new_key} to key vault #{new_keyvault_id}"
      end
      key_vaults << "        - name: #{new_key}\n          alias: #{key}"
    end
  elsif value.is_a?(String)
    puts "    #{key}: \"#{value}\""
  else
    puts "    #{key}: #{value}"
  end
end
puts "  keyVaults:\n    et-pet:\n      secrets:"
key_vaults.each do |key_vault|
  puts key_vault
end
