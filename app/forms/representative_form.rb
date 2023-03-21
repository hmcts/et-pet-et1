class RepresentativeForm < Form
  CONTACT_PREFERENCES = ['email', 'post', 'dx_number'].freeze
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

  before_validation :clear_fields!, unless: :has_representative?
  before_validation :destroy_target!, unless: :has_representative?
  before_validation :clear_contact_preference_fields

  validates :type, :name, presence: true, if: :has_representative?
  validates :type, inclusion: { in: RepresentativeType::TYPES }, if: :has_representative?
  validates :organisation_name, :name, length: { maximum: 100 }
  validates :dx_number, length: { maximum: 40 }
  validates :mobile_number, length: { maximum: PHONE_NUMBER_LENGTH }, ccd_phone: true, allow_blank: true
  validates :email_address, email: true, ccd_email: true, presence: true, if: lambda { |form|
                                                                                form.contact_preference == 'email' && has_representative?
                                                                              }
  validates :contact_preference, presence: true, inclusion: CONTACT_PREFERENCES, if: :has_representative?
  validates :dx_number,  presence: true, dx_string: true, if: ->(form) { form.contact_preference == 'dx_number' && has_representative? }
  validates :has_representative, inclusion: [true, false]

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

  def clear_fields!
    attrs = attributes.keys.each_with_object({}) do |attr_name, obj|
      next if attr_name == "has_representative"

      obj[attr_name.to_sym] = nil
    end
    self.attributes = attrs
  end

  def clear_contact_preference_fields
    case contact_preference
    when 'post'
      self.dx_number = nil
      self.email_address = nil
    when 'email'
      self.dx_number = nil
    else
      self.email_address = nil
    end
  end
end
