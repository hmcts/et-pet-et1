class NilValidator < ActiveModel::EachValidator # :nodoc:
  def validate_each(record, attr_name, value)
    record.errors.add(attr_name, :nil, options) if value.nil?
  end
end
