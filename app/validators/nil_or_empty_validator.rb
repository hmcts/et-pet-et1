class NilOrEmptyValidator < ActiveModel::EachValidator # :nodoc:
  def validate_each(record, attr_name, value)
    record.errors.add(attr_name, :nil_or_empty, **options) if value.nil? || value == ''
  end
end
