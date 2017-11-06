module Refunds
  class FeesForm < Form
    PAYMENT_METHODS = ['card', 'cheque', 'cash', 'unknown'].freeze
    VALID_PAYMENT_DATE_RANGE = Date.parse('1 July 2013')..Date.parse('31 August 2017')
    attribute :et_issue_fee,                            Float
    attribute :et_issue_fee_payment_method,             String
    attribute :et_issue_fee_payment_date,               Date
    attribute :et_issue_fee_payment_date_unknown,       Boolean
    attribute :et_hearing_fee,                          Float
    attribute :et_hearing_fee_payment_method,           String
    attribute :et_hearing_fee_payment_date,               Date
    attribute :et_hearing_fee_payment_date_unknown,       Boolean
    attribute :eat_issue_fee,                           Float
    attribute :eat_issue_fee_payment_method,            String
    attribute :eat_issue_fee_payment_date,               Date
    attribute :eat_issue_fee_payment_date_unknown,       Boolean
    attribute :eat_hearing_fee,                         Float
    attribute :eat_hearing_fee_payment_method,          String
    attribute :eat_hearing_fee_payment_date,               Date
    attribute :eat_hearing_fee_payment_date_unknown,       Boolean
    attribute :et_reconsideration_fee,                 Float
    attribute :et_reconsideration_fee_payment_method,  String
    attribute :et_reconsideration_fee_payment_date,               Date
    attribute :et_reconsideration_fee_payment_date_unknown,       Boolean

    include ::Refunds::FeesFormDateTransform

    validates :et_issue_fee, :et_hearing_fee, :et_reconsideration_fee,
      :eat_issue_fee, :eat_hearing_fee,
      numericality: true, allow_blank: true

    validates :et_issue_fee_payment_method,
      presence: true,
      inclusion: PAYMENT_METHODS,
      if: lambda {
        et_issue_fee.present? && et_issue_fee.positive?
      }

    validates :et_issue_fee_payment_date,
      presence: true,
      date: true,
      date_range: { range: VALID_PAYMENT_DATE_RANGE, format: '%B %Y' },
      if: lambda {
            et_issue_fee.present? &&
              et_issue_fee.positive? &&
              !et_issue_fee_payment_date_unknown?
          }

    validates :et_hearing_fee_payment_method,
      presence: true,
      inclusion: PAYMENT_METHODS,
      if: -> { et_hearing_fee.present? && et_hearing_fee.positive? }

    validates :et_hearing_fee_payment_date,
      presence: true,
      date: true,
      date_range: { range: VALID_PAYMENT_DATE_RANGE, format: '%B %Y' },
      if: lambda {
            et_hearing_fee.present? && et_hearing_fee.positive? && !et_hearing_fee_payment_date_unknown?
          }

    validates :et_reconsideration_fee_payment_method,
      presence: true,
      inclusion: PAYMENT_METHODS,
      if: -> { et_reconsideration_fee.present? && et_reconsideration_fee.positive? }

    validates :et_reconsideration_fee_payment_date,
      presence: true,
      date: true,
      date_range: { range: VALID_PAYMENT_DATE_RANGE, format: '%B %Y' },
      if: lambda {
            et_reconsideration_fee.present? &&
              et_reconsideration_fee.positive? &&
              !et_reconsideration_fee_payment_date_unknown?
          }

    validates :eat_issue_fee_payment_method,
      presence: true,
      inclusion: PAYMENT_METHODS,
      if: lambda {
        eat_issue_fee.present? && eat_issue_fee.positive?
      }

    validates :eat_issue_fee_payment_date,
      presence: true,
      date: true,
      date_range: { range: VALID_PAYMENT_DATE_RANGE, format: '%B %Y' },
      if: lambda {
            eat_issue_fee.present? &&
              eat_issue_fee.positive? &&
              !eat_issue_fee_payment_date_unknown?
          }

    validates :eat_hearing_fee_payment_method,
      presence: true,
      inclusion: PAYMENT_METHODS,
      if: lambda {
        eat_hearing_fee.present? && eat_hearing_fee.positive?
      }

    validates :eat_hearing_fee_payment_date,
      presence: true,
      date: true,
      date_range: { range: VALID_PAYMENT_DATE_RANGE, format: '%B %Y' },
      if: lambda {
            eat_hearing_fee.present? &&
              eat_hearing_fee.positive? &&
              !eat_hearing_fee_payment_date_unknown?
          }

  end
end
