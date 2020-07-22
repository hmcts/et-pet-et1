class AdditionalClaimantsForm < BaseForm
  include ValidateNested
  attribute :has_multiple_claimants, :boolean
  attribute :secondary_claimants
  validate :validate_associated_records_for_secondary_claimants
  before_validation :remove_secondaries, unless: :has_multiple_claimants

  def initialize(claim, *args)
    @_resource = claim
    super(*args)
    self.secondary_claimants = [ClaimantForm.new]
    self.secondary_claimants_to_delete = []
  end

  def form_name
    self.class.model_name_i18n_key.to_s.dasherize
  end

  def self.model_name_i18n_key
    model_name.i18n_key
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, name.underscore.sub(/_form\Z/, ''))
  end

  def secondary_claimants_attributes=(value)
    to_delete_values, claimant_values = value.values.partition do |attrs|
      attrs = attrs.with_indifferent_access
      attrs['_destroy'].present? && ActiveModel::Type::Boolean.new.cast(attrs['_destroy'])
    end
    self.secondary_claimants = claimant_values.map do |attrs|
      ClaimantForm.new(attrs)
    end
    self.secondary_claimants_to_delete = to_delete_values
  end

  # This is to force everything in to thinking we are doing an update all the time ( needed for I18n labels etc.. )
  # @TODO Review if this is really required
  def persisted?
    true
  end

  # @TODO This is for compatibility with old code and is naughty as it is effectively
  # bypassing strong parameters
  # @TODO Work out how to remove this
  def assign_attributes(attrs)
    attrs = attrs.to_unsafe_hash if attrs.respond_to?(:to_unsafe_hash)
    super(attrs)
  end

  def save
    if valid?
      _resource.attributes = persisted_attributes
      _resource.save
    else
      false
    end
  end

  def persisted_attributes
    attributes.except('secondary_claimants', 'secondary_claimants_to_delete')
      .merge 'secondary_claimants_attributes' => secondary_claimants.map(&:persisted_attributes) + secondary_claimants_to_delete
  end

  private

  attr_accessor :_resource
  attribute :secondary_claimants_to_delete

  def validate_associated_records_for_secondary_claimants
    validate_collection_association(:secondary_claimants)
  end

  def remove_secondaries
    secondary_claimants.clear
  end

  class ClaimantForm < BaseForm
    TITLES      = ['mr', 'mrs', 'miss', 'ms'].freeze
    NAME_LENGTH = 100

    include AddressAttributes
    include AgeValidator

    attribute :id
    attribute :first_name,    :string
    attribute :last_name,     :string
    attribute :date_of_birth, :date
    attribute :title,         :string
    attribute :has_special_needs, :boolean
    attribute :has_representative, :boolean

    validates  :date_of_birth, date: true

    validates :title, inclusion: { in: TITLES }, allow_blank: true
    validates :first_name, :last_name, presence: true
    validates :first_name, :last_name, length: { maximum: NAME_LENGTH }
    validate :older_then_16

    def persisted_attributes
      attributes.except('has_special_needs', 'has_representative', 'id')
    end
  end
end
