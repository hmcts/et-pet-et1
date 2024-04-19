module ValidateNested
  extend ActiveSupport::Concern

  private

  # Validate the associated records
  def validate_collection_association(collection_method)
    records = send(collection_method)
    records.each_with_index { |record, index| collection_valid?(collection_method, record, index) }
  end

  # Returns whether or not the collection is valid and applies any errors to
  # the parent, <tt>self</tt>, if it wasn't.
  def collection_valid?(collection_method, record, index = nil)
    return true if record.marked_for_destruction?

    valid = record.valid?
    collection_errors(record, collection_method, index) unless valid
    valid
  end

  def collection_errors(record, collection_method, index)
    normalise_attributes(record, collection_method, index)

    record.errors.details.each_key do |attribute|
      collection_attribute =
        normalize_collection_attribute(collection_method, index, attribute).to_sym

      record.errors.details[attribute].each do |error|
        errors.details[collection_attribute] << error
        errors.details[collection_attribute].uniq!
      end
    end
  end

  def normalise_attributes(record, collection_method, index)
    record.errors.each do |error|
      attribute = normalize_collection_attribute(collection_method, index, error.attribute)
      errors.add(attribute, error.message)
    end
  end

  def normalize_collection_attribute(collection_method, index, attribute)
    "#{collection_method}.attributes.[#{index}].#{attribute}"
  end
end
