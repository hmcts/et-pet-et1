module Refunds
  class BankDetailsForm < Form
    ACCOUNT_TYPES = ['bank', 'building_society'].freeze
    attribute :payment_account_type, String
    attribute :payment_bank_account_name, String
    attribute :payment_bank_name, String
    attribute :payment_bank_account_number, String
    attribute :payment_bank_sort_code, String
    attribute :payment_building_society_account_name, String
    attribute :payment_building_society_name, String
    attribute :payment_building_society_account_number, String
    attribute :payment_building_society_sort_code, String

    validates :payment_account_type, presence: true, inclusion: { in: ACCOUNT_TYPES }
    validates :payment_bank_account_name,
      :payment_bank_name,
      :payment_bank_account_number,
      :payment_bank_sort_code,
      presence: true,
      if: :is_bank_type?
    validates :payment_building_society_account_name,
      :payment_building_society_name,
      :payment_building_society_account_number,
      :payment_building_society_sort_code,
      presence: true,
      if: :is_building_society_type?

    private

    def is_bank_type?
      payment_account_type == 'bank'
    end

    def is_building_society_type?
      payment_account_type == 'building_society'
    end
  end
end
