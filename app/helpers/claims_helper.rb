module ClaimsHelper
  def options_for(model, attribute)
    klass = model.to_s.classify.constantize
    collection = klass.const_get attribute.to_s.pluralize.upcase
    collection.map { |el| [t("enums.#{model}.#{attribute}.#{el}"), el] }
  end
end
