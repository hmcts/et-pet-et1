class AdditionalClaimantsForm
  class AdditionalClaimant < CollectionForm::Resource
    TITLES      = ['mr', 'mrs', 'miss', 'ms'].freeze
    NAME_LENGTH = 100

    include AddressAttributes
    include AgeValidator

    delegate :id, :id=, to: :resource

    attribute :first_name,    :string
    attribute :last_name,     :string
    attribute :date_of_birth, :gds_date_type
    attribute :title,         :string

    booleans   :has_special_needs, :has_representative
    validates  :date_of_birth, date: true

    validates :title, inclusion: { in: TITLES }
    validates :title, :first_name, :last_name, presence: true
    validates :first_name, :last_name, length: { maximum: NAME_LENGTH }
    validate :older_then_16
  end
end
