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

  boolean :has_representative

  before_validation :destroy_target!, unless: :has_representative?

  validates :type, :name, presence: true
  validates :type, inclusion: { in: RepresentativeType::TYPES }
  validates :organisation_name, :name, length: { maximum: 100 }
  validates :dx_number, length: { maximum: 40 }
  validates :mobile_number, length: { maximum: PHONE_NUMBER_LENGTH }, ccd_phone: true, allow_blank: true
  validates :email_address, email: true, ccd_email: true, presence: true, if: ->(form) { form.contact_preference == 'email' }
  validates :contact_preference, presence: true, inclusion: CONTACT_PREFERENCES
  validates :dx_number, presence: true, if: ->(form) { form.contact_preference == 'dx_number' }

  def valid?
    if has_representative?
      super
    else
      run_callbacks(:validation) { true }
    end
  end

  def has_representative
    @has_representative ||= target.persisted?
  end

  def target
    resource.representative || resource.build_representative
  end

  private

  def destroy_target!
    target.destroy
  end
end
