module Refunds
  class FeesForm < Form
    PAYMENT_METHODS = ['card', 'cheque', 'cash'].freeze
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

    validates :et_issue_fee, :et_hearing_fee, :et_reconsideration_fee,
      :eat_issue_fee, :eat_hearing_fee,
      numericality: true, allow_blank: true

    validates :et_issue_fee_payment_method, presence: true,
                                            if: lambda {
                                              et_issue_fee.present? && et_issue_fee.positive?
                                            }

    validates :et_issue_fee_payment_date, presence: true, date: true,
                                          if: lambda {
                                                et_issue_fee.present? &&
                                                  et_issue_fee.positive? &&
                                                  !et_issue_fee_payment_date_unknown?
                                              }

    validates :et_hearing_fee_payment_method,
      presence: true,
      if: -> { et_hearing_fee.present? && et_hearing_fee.positive? }

    validates :et_hearing_fee_payment_date,
      presence: true,
      date: true,
      if: lambda {
            et_hearing_fee.present? && et_hearing_fee.positive? && !et_hearing_fee_payment_date_unknown?
          }

    validates :et_reconsideration_fee_payment_method,
      presence: true,
      if: -> { et_reconsideration_fee.present? && et_reconsideration_fee.positive? }

    validates :et_reconsideration_fee_payment_date,
      presence: true,
      date: true,
      if: lambda {
            et_reconsideration_fee.present? &&
              et_reconsideration_fee.positive? &&
              !et_reconsideration_fee_payment_date_unknown?
          }

    validates :eat_issue_fee_payment_method, presence: true,
                                             if: lambda {
                                               eat_issue_fee.present? &&
                                                 eat_issue_fee.positive?
                                             }

    validates :eat_issue_fee_payment_date, presence: true, date: true,
                                           if: lambda {
                                                 eat_issue_fee.present? &&
                                                   eat_issue_fee.positive? &&
                                                   !eat_issue_fee_payment_date_unknown?
                                               }

    validates :eat_hearing_fee_payment_method, presence: true,
                                               if: lambda {
                                                 eat_hearing_fee.present? &&
                                                   eat_hearing_fee.positive?
                                               }

    validates :eat_hearing_fee_payment_date, presence: true, date: true,
                                             if: lambda {
                                                   eat_hearing_fee.present? &&
                                                     eat_hearing_fee.positive? &&
                                                     !eat_hearing_fee_payment_date_unknown?
                                                 }

    def et_issue_fee_payment_date=(val)
      super(pre_process_partial_date(val, only: :day))
    end

    def et_hearing_fee_payment_date=(val)
      super(pre_process_partial_date(val, only: :day))
    end

    def et_reconsideration_fee_payment_date=(val)
      super(pre_process_partial_date(val, only: :day))
    end

    def eat_issue_fee_payment_date=(val)
      super(pre_process_partial_date(val, only: :day))
    end

    def eat_hearing_fee_payment_date=(val)
      super(pre_process_partial_date(val, only: :day))
    end

    def et_issue_fee
      val = super
      return val if val.nil?
      val.to_f / 100
    end

    def et_issue_fee=(val)
      return super if val.nil?
      super((val.to_f * 100).to_i)
    end

    private

    def pre_process_partial_date(val, options)
      return nil if val.nil? || val.values.all?(&:blank?)
      parts = Array(options.fetch(:only, [:day, :month, :year])).map(&:to_s)
      parts.reduce(val) do |acc, part|
        acc.merge(part => '1') if acc[part].blank?
        acc
      end
    end
  end
end
