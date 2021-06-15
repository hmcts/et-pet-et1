class CcdClaimantContactPreferenceValidator < ActiveModel::EachValidator
  VALUES = ['post', 'email'].freeze
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid_ccd_claimant_contact_preference) unless VALUES.include?(value)
  end
end
