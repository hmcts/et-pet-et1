class CcdPersonalTitleValidator < ActiveModel::EachValidator
  TITLES = ['Mr', 'Mrs', 'Miss', 'Ms', 'Mx', 'Dr', 'Prof', 'Sir', 'Lord', 'Lady', 'Dame', 'Capt', 'Rev', 'Other', 'N/K']

  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid_ccd_personal_title) unless value.nil? || TITLES.include?(value)
  end
end
