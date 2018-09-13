module Refunds
  module FeesFormDateTransform
    extend ActiveSupport::Concern
    included do
      validates :et_issue_fee_payment_date, date: true
      validates :eat_issue_fee_payment_date, date: true
      validates :et_hearing_fee_payment_date, date: true
      validates :eat_hearing_fee_payment_date, date: true
      validates :et_reconsideration_fee_payment_date, date: true
      prepend PreProcess
    end

    module PreProcess
      def et_issue_fee_payment_date=(val)
        write_attribute :et_issue_fee_payment_date, pre_process_partial_date(val, only: :day)
      end

      def et_hearing_fee_payment_date=(val)
        write_attribute :et_hearing_fee_payment_date, pre_process_partial_date(val, only: :day)
      end

      def et_reconsideration_fee_payment_date=(val)
        write_attribute :et_reconsideration_fee_payment_date, pre_process_partial_date(val, only: :day)
      end

      def eat_issue_fee_payment_date=(val)
        write_attribute :eat_issue_fee_payment_date, pre_process_partial_date(val, only: :day)
      end

      def eat_hearing_fee_payment_date=(val)
        write_attribute :eat_hearing_fee_payment_date, pre_process_partial_date(val, only: :day)
      end
    end

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
