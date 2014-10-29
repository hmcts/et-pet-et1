class Jadu::AddressSerializer < Jadu::BaseSerializer
  def building_split(building)
    @building_split ||= building.strip.scan(/(^[0-9]{0,4})(.*)/).flatten if building
  end

  def address_number(building)
    number = building_split(building)[0]
    number.present? ? number.to_i : nil
  end

  def address_name(building)
    building_split(building)[1].strip
  end

  def to_xml(options={})
    xml = builder(options)
    xml.Address do
      xml.Number address_number(building)
      xml.Name address_name(building)
      xml.Street street
      xml.Town locality
      xml.County county
      xml.Postcode post_code
    end
  end
end
