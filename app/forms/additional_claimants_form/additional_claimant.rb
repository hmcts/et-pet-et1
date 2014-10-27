class AdditionalClaimantsForm
  class AdditionalClaimant < Form
    attr_accessor :target

    TITLES      = %w<mr mrs ms miss>.freeze
    NAME_LENGTH = 100

    include AddressAttributes

    delegate :id, :id=, to: :resource

    attributes :first_name, :last_name, :date_of_birth, :title
    booleans   :has_special_needs, :has_representative

    validates :title, inclusion: { in: TITLES }
    validates :title, :first_name, :last_name, presence: true
    validates :first_name, :last_name, length: { maximum: NAME_LENGTH }
  end
end
