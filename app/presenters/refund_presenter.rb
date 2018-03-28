class RefundPresenter < Presenter
  FEE_LIST = [:et_issue, :et_hearing, :et_reconsideration,
              :eat_issue, :eat_hearing].freeze

  def applicant_address_building_street
    "#{applicant_address_building} #{applicant_address_street}"
  end

  def applicant_address_locality_county
    "#{applicant_address_locality}/#{applicant_address_county}"
  end

  def original_applicant_address_building_street
    "#{claimant_address_building} #{claimant_address_street}"
  end

  def original_applicant_address_locality_county
    "#{claimant_address_locality}/#{claimant_address_county}"
  end

  def list_fee_types
    fee_data { |fee_key| fee_name(fee_key) }
  end

  def bank_details
    if payment_bank_name
      "#{payment_bank_name} #{payment_bank_account_name}"
    elsif payment_building_society_name
      "#{payment_building_society_name} #{payment_building_society_account_name}"
    end
  end

  def bank_sort_code
    if payment_bank_sort_code
      payment_bank_sort_code
    elsif payment_building_society_sort_code
      payment_building_society_sort_code
    end
  end

  def bank_account_number
    if payment_bank_account_number
      payment_bank_account_number
    elsif payment_building_society_account_number
      payment_building_society_account_number
    end
  end

  def list_fee_payment_dates
    fee_data do |fee_key|
      next if send("#{fee_key}_fee_payment_date").blank?
      name = fee_name(fee_key)
      date = send("#{fee_key}_fee_payment_date").strftime('%Y/%m')
      "#{name}: #{date}"
    end
  end

  def list_fee_amounts
    fee_data do |fee_key|
      name = fee_name(fee_key)
      amount = send("#{fee_key}_fee")
      currency = send("#{fee_key}_fee_currency")
      "#{name}: #{amount} #{currency}"
    end
  end

  def list_fee_payment_method
    fee_data do |fee_key|
      name = fee_name(fee_key)
      payment_method = send("#{fee_key}_fee_payment_method")
      "#{name}: #{payment_method}"
    end
  end

  def fee_name(fee_key)
    I18n.t("refunds.review.#{fee_key}_fee")
  end

  def fee_data
    FEE_LIST.map do |fee_key|
      next if send("#{fee_key}_fee").blank?
      yield(fee_key)
    end.compact.join("\n")
  end

end
