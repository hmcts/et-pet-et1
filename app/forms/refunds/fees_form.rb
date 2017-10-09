module Refunds
  class FeesForm < Form
    PAYMENT_METHODS = ['card', 'cheque', 'cash', 'unknown'].freeze
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
    dates :et_issue_fee_payment_date, :et_hearing_fee_payment_date, :eat_issue_fee_payment_date
    dates :eat_hearing_fee_payment_date, :et_reconsideration_fee_payment_date
    validates :et_issue_fee, :et_hearing_fee, :et_reconsideration_fee,
      :eat_issue_fee, :eat_hearing_fee,
      numericality: true, allow_blank: true

    validates :et_issue_fee_payment_method,
      presence: true,
      inclusion: PAYMENT_METHODS,
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
      inclusion: PAYMENT_METHODS,
      if: -> { et_hearing_fee.present? && et_hearing_fee.positive? }

    validates :et_hearing_fee_payment_date,
      presence: true,
      date: true,
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

    validates :eat_issue_fee_payment_date, presence: true, date: true,
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

    validates :eat_hearing_fee_payment_date, presence: true, date: true,
                                             if: lambda {
                                                   eat_hearing_fee.present? &&
                                                     eat_hearing_fee.positive? &&
                                                     !eat_hearing_fee_payment_date_unknown?
                                                 }

    def et_issue_fee_payment_date_with_pre_process=(val)
      self.et_issue_fee_payment_date_without_pre_process = pre_process_partial_date(val, only: :day)
    end
    alias_method_chain :et_issue_fee_payment_date=, :pre_process

    def et_hearing_fee_payment_date_with_pre_process=(val)
      self.et_hearing_fee_payment_date_without_pre_process = pre_process_partial_date(val, only: :day)
    end
    alias_method_chain :et_hearing_fee_payment_date=, :pre_process

    def et_reconsideration_fee_payment_date_with_pre_process=(val)
      self.et_reconsideration_fee_payment_date_without_pre_process = pre_process_partial_date(val, only: :day)
    end
    alias_method_chain :et_reconsideration_fee_payment_date=, :pre_process

    def eat_issue_fee_payment_date_with_pre_process=(val)
      self.eat_issue_fee_payment_date_without_pre_process = pre_process_partial_date(val, only: :day)
    end
    alias_method_chain :eat_issue_fee_payment_date=, :pre_process

    def eat_hearing_fee_payment_date_with_pre_process=(val)
      self.eat_hearing_fee_payment_date_without_pre_process = pre_process_partial_date(val, only: :day)
    end
    alias_method_chain :eat_hearing_fee_payment_date=, :pre_process

    private

    def pre_process_partial_date(val, options)
      val = attempt_date_parse(val)
      return val if val.is_a?(Date) || val.is_a?(DateTime)
      convert_partial_date(options, val) unless val.nil? || is_empty_date_hash?(val)
    end

    def attempt_date_parse(val)
      return val unless val.is_a?(String) && val =~ %r(\A\d{4}\-\d{2}\-\d{2}\z)
      Date.parse(val)
    rescue ArgumentError
      val
    end

    def is_empty_date_hash?(val)
      val.respond_to?(:values) && val.values.all?(&:blank?)
    end

    def convert_partial_date(options, val)
      parts = Array(options.fetch(:only, [:day, :month, :year])).map(&:to_s)
      parts.reduce(val) do |acc, part|
        next acc.merge(part => '1') if acc[part].blank?
        acc
      end
    end
  end
end
