class Refund < ActiveRecord::Base
  REFERENCE_START = 1000000

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

  def total_fees
    [:et_issue_fee, :et_hearing_fee, :et_reconsideration_fee, :eat_issue_fee, :eat_hearing_fee].reduce(0) do |sum, fee|
      sum + (send(fee) || 0)
    end
  end

  def et_issue_fee_present?
    et_issue_fee.present? && et_issue_fee.positive?
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

  class << self
    def to_csv(ids)
      CSV.generate(headers: true) do |csv|
        csv << export_headers

        Refund.where(id: ids).each do |refund|
          presenter_refund = RefundPresenter.new(refund)
          line = csv_attributes.map { |attribute| presenter_refund.try(attribute).to_s }
          csv << line.flatten
        end
      end
    end

    def export_headers
      ['Sumbission reference number', 'First name', 'Surname', '', '', 'Building number or name/Street',
        'Town/City', 'UK Postcode', 'Date of birth', 'Email address', 'Bank account holder name',
        'Bank sort code', 'Bank account number',
        'Employment tribunal case number', 'Additional information', 'Fee type', 'Payment date (yyyy/mm)',
        'Fee (in pounds)', 'Payment method', '', '', '', '', '', 'Building number or name Street',
        'Town/City', 'UK Postcode', '', '', '', '']
    end

    def csv_attributes
      [:application_reference_number, :applicant_first_name, :applicant_last_name, '','',
        :applicant_address_building_street, :applicant_address_locality_county,
        :applicant_address_post_code, :applicant_date_of_birth,
        :email_address, :bank_details, :payment_bank_sort_code, :payment_bank_account_number,
        :et_case_number, :additional_information, :list_fee_types,
        :list_fee_payment_dates, :list_fee_amounts, :list_fee_payment_method,
        '','','','','', :original_applicant_address_building_street,
        :original_applicant_address_locality_county, :claimant_address_post_code,
        '','','','']
    end
  end

end
