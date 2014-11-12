class AdditionalClaimantsForm
  class AdditionalClaimant < Form
    boolean :_destroy

    TITLES      = %w<mr mrs miss ms>.freeze
    NAME_LENGTH = 100

    include AddressAttributes

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

    def valid?
      if _destroy?
        true
      else
        super
      end
    end

    def save
      case
      when _destroy?
        !!target.destroy
      when valid?
        !!target.update_attributes(attributes)
      else
        false
      end
    end
  end
end
