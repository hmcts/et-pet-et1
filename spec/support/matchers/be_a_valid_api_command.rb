# A matcher for proving the JSON that will be given to the API
# This doesnt do the matching itself, it relies on the different 'JsonObject's for all of the different types of data
# These objects must define the has_valid_json_for_model? method for this to work
RSpec::Matchers.define :be_a_valid_api_command do |command|
  chain :version do |version|
    @version = version
  end
  chain :for_db_data do |db_data|
    @db_data = db_data
  end

  errors = []

  match do |json|
    raise "Version must be set - please add .version(2) for example to be_a_valid_api_command" unless defined? @version
    json_object_class_name = "::Et1::Test::JsonObjects::V#{@version}::#{command}JsonObject"
    json_object_class = json_object_class_name.safe_constantize
    raise "No 'Json Object' defined for #{command} - Please define #{json_object_class_name} in spec/support/api_support....." if json_object_class.nil?
    json_object = json_object_class.new(json)
    if defined?(@db_data)
      json_object.has_valid_json_for_model?(@db_data, errors: errors)
      errors.empty?
    else
      raise "The be_a_valid_api_command was used but no input data to compare against - please add .db_data(model_instance) for example"
    end
  end

  failure_message do |actual|
    "Expected #{actual} to be a valid api command for #{command} but it wasn't\n\nThe errors reported were: \n\n#{errors.join("\n")}"
  end

end
