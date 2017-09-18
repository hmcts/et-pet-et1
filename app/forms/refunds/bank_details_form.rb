module Refunds
  class BankDetailsForm < Form
    ACCOUNT_TYPES = ['bank', 'building_society']
    attribute :payment_account_type, String
    attribute :payment_account_name,  String
    attribute :payment_bank_name,  String
    attribute :payment_account_number,  String
    attribute :payment_sort_code,  String

    validates :payment_account_type, presence: true, inclusion: {in: ACCOUNT_TYPES}
  end
end
