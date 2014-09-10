class Address < ActiveRecord::Base
  include JaduFormattable

  belongs_to :addressable, polymorphic: true

  def to_xml(options={})
    require 'builder'
    xml = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
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
