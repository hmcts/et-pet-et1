class RepresentativeForm < Form
  TYPES = %i<citizen_advice_bureau free_representation_unit law_centre trade_union
             solicitor private_individual trade_association other>.freeze

  CONTACT_PREFERENCES = %i<email post fax>.freeze

  attributes :type, :organisation_name, :name, :address_telephone_number,
             :mobile_number, :email_address, :dx_number, :address_building,
             :address_street, :address_locality, :address_county,
             :address_post_code, :contact_preference

  validates :type, inclusion: { in: TYPES.map(&:to_s) }
  validates :name, :address_building, :address_street,
            :address_locality, :address_post_code, presence: true

  validates :organisation_name, :name, length: { maximum: 100 }
  validates :address_building, length: { maximum: 75 }
  validates :address_street, :address_locality, length: { maximum: 30 }
  validates :address_county, length: { maximum: 25 }
  validates :address_post_code, length: { maximum: 8 }
  validates :address_telephone_number, :mobile_number, length: { maximum: 15 }
  validates :dx_number, length: { maximum: 20 }

  private def target
    resource.representative || resource.build_representative
  end
end
