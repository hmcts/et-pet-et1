class Claimant < ActiveRecord::Base
  include JaduFormattable

  belongs_to :claim
  has_one :address, as: :addressable, autosave: true

  delegate :building, :street, :locality, :county, :post_code, :telephone_number, :country,
    :building=, :street=, :locality=, :county=, :post_code=, :telephone_number=, :country=,
    to: :address, prefix: true

  def address
    super || build_address
  end

  def primary_claimant?
    self == claim.primary_claimant
  end

  def to_xml(options={})
    require 'builder'
    xml = options[:builder] ||= ::Builder::XmlMarkup.new(indent: options[:indent])
    xml.Claimant do
      xml.GroupContact primary_claimant?
      xml.Title title
      xml.Forename first_name
      xml.Surname last_name
      xml.OfficeNumber address_telephone_number
      xml.AltPhoneNumber mobile_number
      xml.Email email_address
      xml.Fax fax_number
      xml.PreferredContactMethod contact_preference.humanize
    end
  end
end
