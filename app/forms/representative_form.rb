class RepresentativeForm < Form
  CONTACT_PREFERENCES  = ['email', 'post', 'dx_number'].freeze
  include AddressAttributes

  attribute :type,               :string
  attribute :name,               :string
  attribute :organisation_name,  :string
  attribute :mobile_number,      :string
  attribute :email_address,      :string
  attribute :dx_number,          :string
  attribute :contact_preference, :string
  attribute :has_representative, :boolean
  map_attribute :has_representative, to: :resource

  before_validation :destroy_target!, unless: :has_representative?

  validates :type, :name, presence: true, if: :has_representative?
  validates :type, inclusion: { in: RepresentativeType::TYPES }, if: :has_representative?
  validates :organisation_name, :name, length: { maximum: 100 }
  validates :dx_number, length: { maximum: 40 }
  validates :mobile_number, length: { maximum: PHONE_NUMBER_LENGTH }, ccd_phone: true, allow_blank: true
  validates :email_address, email: true, ccd_email: true, presence: true, if: ->(form) { form.contact_preference == 'email' && has_representative? }
  validates :contact_preference, presence: true, inclusion: CONTACT_PREFERENCES, if: :has_representative?
  validates :dx_number, presence: true, if: ->(form) { form.contact_preference == 'dx_number' && has_representative? }
  validates :has_representative, inclusion: [true, false]

  def initialize(resource, **attrs)
    super
  end

  def skip_address_validation?
    !has_representative?
  end

  def target
    resource.representative || resource.build_representative
  end

  private

  def destroy_target!
    target.destroy
  end
end
