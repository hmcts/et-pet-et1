class AdditionalClaimantsForm
  class AdditionalClaimant < CollectionForm::Resource
    TITLES      = %w[mr mrs miss ms].freeze
    NAME_LENGTH = 100

    include AddressAttributes
    include AgeValidator

    delegate :id, :id=, to: :resource

    attribute :first_name,    String
    attribute :last_name,     String
    attribute :date_of_birth, Date
    attribute :title,         String

    booleans   :has_special_needs, :has_representative
    dates      :date_of_birth

    validates :title, inclusion: { in: TITLES }
    validates :title, :first_name, :last_name, presence: true
    validates :first_name, :last_name, length: { maximum: NAME_LENGTH }
    validate :older_then_16
  end
end
