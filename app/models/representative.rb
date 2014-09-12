class Representative < ActiveRecord::Base
  include JaduFormattable

  self.inheritance_column = nil

  belongs_to :claim
  has_one :address, as: :addressable, autosave: true

  delegate :building, :street, :locality, :county, :post_code, :telephone_number,
    :building=, :street=, :locality=, :county=, :post_code=, :telephone_number=,
    to: :address, prefix: true

  def address
    super || build_address
  end

  def to_xml(options={})
    require 'builder'
    xml = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
    xml.Representatives do
      xml.Representative do
        xml.Name name
        xml.OfficeNumber address_telephone_number
        xml.AltPhoneNumber mobile_number
        xml.Email email_address
        xml.ClaimantOrRespondent 'C'
      end
    end
  end
end
