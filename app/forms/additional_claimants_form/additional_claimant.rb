class AdditionalClaimantsForm
  class AdditionalClaimant < Form
    attr_accessor :target

    TITLES = %i<mr mrs ms miss>.freeze

    include AddressAttributes

    delegate :id, :id=, to: :resource

    attributes :first_name, :last_name, :date_of_birth, :title
    booleans   :has_special_needs, :has_representative

    validates_address(self)
    validates :title, inclusion: { in: TITLES.map(&:to_s) }
    validates :title, :first_name, :last_name, presence: true
    validates :first_name, :last_name, length: { maximum: NAME_LENGTH }
  end
end
