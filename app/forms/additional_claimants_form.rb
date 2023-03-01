class AdditionalClaimantsForm < Form
  include ValidateNested
  attribute :has_multiple_claimants, :boolean
  attribute :secondary_claimants
  transient_attributes :secondary_claimants
  validate :validate_associated_records_for_secondary_claimants
  before_validation :remove_secondaries, unless: :has_multiple_claimants
  has_many_forms :secondary_claimants, class_name: '::AdditionalClaimantsForm::ClaimantForm'

  validates :has_multiple_claimants, inclusion: [true, false]

  private

  attr_accessor :_resource

  def validate_associated_records_for_secondary_claimants
    validate_collection_association(:secondary_claimants)
  end

  def remove_secondaries
    secondary_claimants.clear
  end

  class ClaimantForm < Form
    TITLES      = ['Mr', 'Mrs', 'Miss', 'Ms'].freeze
    NAME_LENGTH = 100
    transient_attributes :has_special_needs, :has_representative
    include AddressAttributes

    attribute :id
    attribute :first_name,    :string
    attribute :last_name,     :string
    attribute :date_of_birth, :et_date
    attribute :title,         :string
    attribute :has_special_needs, :boolean
    attribute :has_representative, :boolean

    validates :date_of_birth, date: true, date_range: { range: -> { 100.years.ago..10.years.ago } }, presence: true
    validates :title, inclusion: { in: TITLES }, allow_blank: true
    validates :first_name, :last_name, presence: true, length: { maximum: NAME_LENGTH }

    before_validation :clean_empty_title

    private

    def clean_empty_title
      self.title = nil if title == ''
    end
  end
end
