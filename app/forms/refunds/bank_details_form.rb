module Refunds
  class BankDetailsForm < Form
    attribute :payment_account_name,  String
    attribute :payment_bank_name,  String
    attribute :payment_account_number,  String
    attribute :payment_sort_code,  String
  end
end
