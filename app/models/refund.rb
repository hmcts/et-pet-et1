class Refund < ActiveRecord::Base
  REFERENCE_START = 1000000
  alias_attribute :address_building, :applicant_address_building
  alias_attribute :address_street, :applicant_address_street
  alias_attribute :address_locality, :applicant_address_locality
  alias_attribute :address_county, :applicant_address_county
  alias_attribute :address_post_code, :applicant_address_post_code
  alias_attribute :address_telephone_number, :applicant_address_telephone_number
  alias_attribute :title, :applicant_title
  alias_attribute :first_name, :applicant_first_name
  alias_attribute :last_name, :applicant_last_name
  alias_attribute :date_of_birth, :applicant_date_of_birth

  def generate_application_reference
    last = self.class.maximum(:application_reference_number)
    last = REFERENCE_START if last.nil?
    self.application_reference_number = last + 1
    self.application_reference = "C#{application_reference_number}"
  end

  def generate_submitted_at
    self.submitted_at = Time.now.utc
  end

  def has_fees?
    [:et_issue_fee, :et_hearing_fee, :et_reconsideration_fee, :eat_issue_fee, :eat_hearing_fee].any? do |fee|
      send("#{fee}_present?")
    end
  end

  def et_issue_fee_present?
    et_issue_fee.present? and et_issue_fee.positive?
  end

  def et_hearing_fee_present?
    et_hearing_fee.present? && et_hearing_fee.positive?
  end

  def et_reconsideration_fee_present?
    et_reconsideration_fee.present? && et_reconsideration_fee.positive?
  end

  def eat_issue_fee_present?
    eat_issue_fee.present? && eat_issue_fee.positive?
  end

  def eat_hearing_fee_present?
    eat_hearing_fee.present? && eat_hearing_fee.positive?
  end
end
