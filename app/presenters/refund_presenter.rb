class RefundPresenter < Presenter
  FEE_LIST = [:et_issue, :et_hearing, :et_reconsideration,
    :eat_issue, :eat_hearing].freeze

  def applicant_address_building_street
    "#{self.applicant_address_building} #{self.applicant_address_street}"
  end

  def applicant_address_locality_county
    "#{self.applicant_address_locality}/#{self.applicant_address_county}"
  end

  def original_applicant_address_building_street
    "#{self.claimant_address_building} #{self.claimant_address_street}"
  end

  def original_applicant_address_locality_county
    "#{self.claimant_address_locality}/#{self.claimant_address_county}"
  end

  def list_fee_types
    FEE_LIST.map do |fee_name|
      I18n.t("refunds.review.#{fee_name}_fee")
    end.join("\n")
  end

  def list_fee_payment_dates
    FEE_LIST.map do |fee_name|
      next if self.send("#{fee_name}_fee_payment_date").blank?
      name = I18n.t("refunds.review.#{fee_name}_fee")
      date = send("#{fee_name}_fee_payment_date").strftime('%Y/%m')
      "#{name}: #{date}"
    end.compact.join("\n")
  end

  def list_fee_amounts
    FEE_LIST.map do |fee_name|
      name = I18n.t("refunds.review.#{fee_name}_fee")
      amount = self.send("#{fee_name}_fee")
      currency = self.send("#{fee_name}_fee_currency")
      "#{name}: #{amount} #{currency}"
    end.join("\n")
  end

  def list_fee_payment_method
    FEE_LIST.map do |fee_name|
      next if self.send("#{fee_name}_fee").blank?
      name = I18n.t("refunds.review.#{fee_name}_fee")
      payment_method = send("#{fee_name}_fee_payment_method")
      "#{name}: #{payment_method}"
    end.join("\n")
  end

  def bank_details
    "#{self.payment_bank_name} #{payment_bank_account_name}"
  end
end
