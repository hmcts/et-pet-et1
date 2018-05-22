module Refunds
  class BankDetailsForm < Form
    attribute :payment_bank_account_name, String
    attribute :payment_bank_name, String
    attribute :payment_bank_account_number, String
    attribute :payment_bank_sort_code, String

    validates :payment_bank_account_name, :payment_bank_name, presence: true
    validates :payment_bank_account_number,
      presence: true,
      format: { with: %r(\A\d{8}\z), allow_blank: true }
    validates :payment_bank_sort_code,
      presence: true,
      format: { with: %r(\A\d{6}\z), allow_blank: true }

  end
end
