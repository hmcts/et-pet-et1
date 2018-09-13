module Refunds
  class BankDetailsForm < Form
    ACCOUNT_TYPES = ['bank', 'building_society'].freeze
    attribute :payment_account_type, :string
    attribute :payment_bank_account_name, :string
    attribute :payment_bank_name, :string
    attribute :payment_bank_account_number, :string
    attribute :payment_bank_sort_code, :string
    attribute :payment_building_society_account_name, :string
    attribute :payment_building_society_name, :string
    attribute :payment_building_society_account_number, :string
    attribute :payment_building_society_sort_code, :string

    validates :payment_account_type, presence: true, inclusion: { in: ACCOUNT_TYPES }
    validates :payment_bank_account_name, :payment_bank_name, presence: true, if: :is_bank_type?
    validates :payment_bank_account_number,
      presence: true,
      format: { with: %r(\A\d{8}\z), allow_blank: true },
      if: :is_bank_type?
    validates :payment_bank_sort_code,
      presence: true,
      format: { with: %r(\A\d{6}\z), allow_blank: true },
      if: :is_bank_type?
    validates :payment_building_society_account_name,
      :payment_building_society_name,
      presence: true,
      if: :is_building_society_type?
    validates :payment_building_society_account_number,
      presence: true,
      format: { with: %r(\A\d{8}\z), allow_blank: true },
      if: :is_building_society_type?
    validates :payment_building_society_sort_code,
      presence: true,
      format: { with: %r(\A\d{6}\z), allow_blank: true },
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
