class RepresentativeForm < Form
  TYPES = %i<citizen_advice_bureau free_representation_unit law_centre trade_union
             solicitor private_individual trade_association other>.freeze

  CONTACT_PREFERENCES = %i<email post fax>.freeze

  attributes :type, :organisation_name, :name,
             :mobile_number, :email_address, :dx_number,
             :contact_preference

  include AddressAttributes

  validates :type, inclusion: { in: TYPES.map(&:to_s) }
  validates :name, presence: true
  validates :organisation_name, :name, length: { maximum: 100 }
  validates :dx_number, length: { maximum: 20 }
  validates :mobile_number, length: { maximum: PHONE_NUMBER_LENGTH }

  private def target
    resource.representative || resource.build_representative
  end
end
