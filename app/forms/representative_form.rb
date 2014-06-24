class RepresentativeForm < Form
  ADDRESS_REGEXP = /\Aaddress_/
  TYPES = %i<citizen_advice_bureau free_representation_unit law_centre trade_union
             solicitor private_individual trade_association other>.freeze

  attributes :type, :organisation_name, :name, :telephone_number,
             :mobile_number, :email_address, :dx_number, :address_building,
             :address_street, :address_locality, :address_county,
             :address_post_code

  validates :type, inclusion: { in: TYPES.map(&:to_s) }
  validates :name, :address_building, :address_street,
            :address_locality, :address_post_code, presence: true

  validates :organisation_name, :name, length: { maximum: 100 }
  validates :address_building, length: { maximum: 75 }
  validates :address_street, :address_locality, length: { maximum: 30 }
  validates :address_county, length: { maximum: 25 }
  validates :address_post_code, length: { maximum: 8 }
  validates :telephone_number, :mobile_number, length: { maximum: 15 }
  validates :dx_number, length: { maximum: 20 }

  def save
    if valid?
      extractor = AttributeExtractor.new(attributes)
      representative = resource.build_representative(extractor =~ /\A(?!#{ADDRESS_REGEXP})/)
      representative.build_address(extractor =~ ADDRESS_REGEXP)
      resource.save
    end
  end

end
