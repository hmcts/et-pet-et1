class RepresentativeForm < Form
  ADDRESS_REGEXP = /\Aaddress_/
  TYPES = %i<citizen_advice_bureau free_representation_unit law_centre trade_union
             solicitor private_individual trade_association other>.freeze

  attributes :type, :organisation_name, :name, :address_telephone_number,
             :mobile_number, :email_address, :dx_number, :address_building,
             :address_street, :address_locality, :address_county,
             :address_post_code

  def save
    if valid?
      extractor = AttributeExtractor.new(attributes)
      representative = resource.build_representative(extractor =~ /\A(?!#{ADDRESS_REGEXP})/)
      representative.build_address(extractor =~ ADDRESS_REGEXP)
      resource.save
    end
  end

end
