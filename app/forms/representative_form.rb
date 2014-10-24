class RepresentativeForm < Form
  include AddressAttributes

  attributes :type, :organisation_name, :name,
             :mobile_number, :email_address, :dx_number,
             :contact_preference

  boolean :has_representative

  before_save :clear_irrelevant_fields

  with_options if: :has_representative? do |rep|
    validates_address(rep)

    rep.validates :type, :name, presence: true
    rep.validates :type, inclusion: { in: FormOptions::REPRESENTATIVE_TYPES.map(&:to_s) }
    rep.validates :organisation_name, :name, length: { maximum: 100 }
    rep.validates :dx_number, length: { maximum: 20 }
    rep.validates :mobile_number, length: { maximum: PHONE_NUMBER_LENGTH }
  end

  def has_representative
    @has_representative ||= target.persisted?
  end

  private

  def clear_irrelevant_fields
    target.destroy unless has_representative?
  end

  def target
    resource.representative || resource.build_representative
  end
end
