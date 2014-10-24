class RepresentativeForm < Form
  include AddressAttributes

  attributes :type, :organisation_name, :name,
             :mobile_number, :email_address, :dx_number,
             :contact_preference

  validates :type, :name, presence: true

  validates :type, inclusion: { in: FormOptions::REPRESENTATIVE_TYPES.map(&:to_s) }
  validates :organisation_name, :name, length: { maximum: 100 }
  validates :dx_number, length: { maximum: 20 }
  validates :mobile_number, length: { maximum: PHONE_NUMBER_LENGTH }

  boolean :has_representative

  def has_representative
    @has_representative ||= target.persisted?
  end

  def valid?
    if has_representative?
      super
    else
      true
    end
  end

  private

  def clear_irrelevant_fields
    target.destroy unless has_representative?
  end

  def target
    resource.representative || resource.build_representative
  end
end
