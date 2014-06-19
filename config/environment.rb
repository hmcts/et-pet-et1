# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord::ConnectionAdapters
  class Column
    private def simplified_type_with_custom_type(field_type)
      if %w<gender contact_preference person_title>.include? field_type
        field_type.to_sym
      else
        simplified_type_without_custom_type(field_type)
      end
    end

    alias_method_chain :simplified_type, :custom_type
  end

  class PostgreSQLAdapter
    NATIVE_DATABASE_TYPES.update \
      contact_preference: { name: "contact_preference" },
      gender:             { name: "gender" },
      person_title:       { name: "person_title" }


    OID.alias_type 'gender', 'string'
    OID.alias_type 'contact_preference', 'string'
    OID.alias_type 'person_title', 'string'
  end
end
