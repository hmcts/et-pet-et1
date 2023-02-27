class CcdAcasExemptionReasonValidator < ActiveModel::EachValidator
  VALUES = ['joint_claimant_has_acas_number', 'acas_has_no_jurisdiction', 'employer_contacted_acas',
            'interim_relief'].freeze

  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid_cdd_acas_exemption_reason) unless VALUES.include?(value)
  end
end
