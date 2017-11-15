class RefundCSVExport

  def initialize(ids)
    @refund_ids = ids
  end

  def run
    CSV.generate(headers: true) do |csv|
      csv << export_headers

      Refund.where(id: @refund_ids).find_each do |refund|
        presenter_refund = RefundPresenter.new(refund)
        line = csv_attributes.map { |attribute| presenter_refund.try(attribute).to_s }
        csv << line.flatten
      end
    end
  end

  def export_headers
    ['Sumbission reference number', 'First name', 'Surname', '', '', 'Building number/Street name',
     'Town/City', 'UK Postcode', 'Date of birth', 'Email address', 'Bank account holder name',
     'Bank sort code', 'Bank account number',
     'Employment tribunal case number', 'Additional information', 'Fee type', 'Payment date (yyyy/mm)',
     'Fee (in pounds)', 'Payment method', '', '', '', '', '', 'Building number/Street name',
     'Town/City', 'UK Postcode', '', '', '', '']
  end

  def csv_attributes
    [:application_reference_number, :applicant_first_name, :applicant_last_name, '', '',
     :applicant_address_building_street, :applicant_address_locality_county,
     :applicant_address_post_code, :applicant_date_of_birth,
     :email_address, :bank_details, :bank_sort_code, :bank_account_number,
     :et_case_number, :additional_information, :list_fee_types,
     :list_fee_payment_dates, :list_fee_amounts, :list_fee_payment_method,
     '', '', '', '', '', :original_applicant_address_building_street,
     :original_applicant_address_locality_county, :claimant_address_post_code,
     '', '', '', '']
  end
end
