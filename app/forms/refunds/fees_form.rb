module Refunds
  class FeesForm < Form
    PAYMENT_METHODS = ['card', 'cheque', 'cash', 'unknown'].freeze
    VALID_PAYMENT_DATE_RANGE = Date.parse('1 July 2013')..Date.parse('31 August 2017')
    attribute :et_issue_fee,                            Integer
    attribute :et_issue_fee_payment_method,             String
    attribute :et_issue_fee_payment_date,               Date
    attribute :et_issue_fee_payment_date_unknown,       Boolean
    attribute :et_hearing_fee,                          Integer
    attribute :et_hearing_fee_payment_method,           String
    attribute :et_hearing_fee_payment_date,               Date
    attribute :et_hearing_fee_payment_date_unknown,       Boolean
    attribute :eat_issue_fee,                           Integer
    attribute :eat_issue_fee_payment_method,            String
    attribute :eat_issue_fee_payment_date,               Date
    attribute :eat_issue_fee_payment_date_unknown,       Boolean
    attribute :eat_hearing_fee,                         Integer
    attribute :eat_hearing_fee_payment_method,          String
    attribute :eat_hearing_fee_payment_date,               Date
    attribute :eat_hearing_fee_payment_date_unknown,       Boolean
    attribute :et_reconsideration_fee,                 Integer
    attribute :et_reconsideration_fee_payment_method,  String
    attribute :et_reconsideration_fee_payment_date,               Date
    attribute :et_reconsideration_fee_payment_date_unknown,       Boolean

    include ::Refunds::FeesFormDateTransform

    validates :et_issue_fee, :et_hearing_fee, :et_reconsideration_fee,
      :eat_issue_fee, :eat_hearing_fee,
      numericality: { greater_than_or_equal_to: 0 },
      allow_blank: true

    validates :et_issue_fee_payment_method,
      presence: true,
      inclusion: PAYMENT_METHODS,
      if: -> { et_issue_fee.try(:positive?) }

    validates :et_issue_fee_payment_date,
      presence: true,
      date: true,
      date_range: { range: VALID_PAYMENT_DATE_RANGE, format: '%B %Y' },
      if: -> { et_issue_fee.try(:positive?) && !et_issue_fee_payment_date_unknown? }

    validates :et_hearing_fee_payment_method,
      presence: true,
      inclusion: PAYMENT_METHODS,
      if: -> { et_hearing_fee.try(:positive?) }

    validates :et_hearing_fee_payment_date,
      presence: true,
      date: true,
      date_range: { range: VALID_PAYMENT_DATE_RANGE, format: '%B %Y' },
      if: -> { et_hearing_fee.try(:positive?) && !et_hearing_fee_payment_date_unknown? }

    validates :et_reconsideration_fee_payment_method,
      presence: true,
      inclusion: PAYMENT_METHODS,
      if: -> {  et_reconsideration_fee.try(:positive?) }

    validates :et_reconsideration_fee_payment_date,
      presence: true,
      date: true,
      date_range: { range: VALID_PAYMENT_DATE_RANGE, format: '%B %Y' },
      if: -> { et_reconsideration_fee.try(:positive?) && !et_reconsideration_fee_payment_date_unknown? }

    validates :eat_issue_fee_payment_method,
      presence: true,
      inclusion: PAYMENT_METHODS,
      if: -> { eat_issue_fee.try(:positive?) }

    validates :eat_issue_fee_payment_date,
      presence: true,
      date: true,
      date_range: { range: VALID_PAYMENT_DATE_RANGE, format: '%B %Y' },
      if: -> { eat_issue_fee.try(:positive?) && !eat_issue_fee_payment_date_unknown? }

    validates :eat_hearing_fee_payment_method,
      presence: true,
      inclusion: PAYMENT_METHODS,
      if: -> { eat_hearing_fee.try(:positive?) }

    validates :eat_hearing_fee_payment_date,
      presence: true,
      date: true,
      date_range: { range: VALID_PAYMENT_DATE_RANGE, format: '%B %Y' },
      if: -> { eat_hearing_fee.try(:positive?) && !eat_hearing_fee_payment_date_unknown? }

    validate :validate_fees

    private

    def total_fees
      [:et_issue_fee, :et_hearing_fee, :et_reconsideration_fee, :eat_issue_fee, :eat_hearing_fee].sum do |fee|
        send(fee).to_f
      end
    end

    def validate_fees
      errors.add(:base, :fees_must_be_positive) unless total_fees.try(:positive?)
    end
  end
end
