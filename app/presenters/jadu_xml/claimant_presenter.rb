module JaduXml
  class ClaimantPresenter < XmlPresenter
    property :primary_claimant, as: "GroupContact"
    property :title, as: "Title"
    property :first_name, as: "Forename"
    property :last_name, as: "Surname"
    property :address, extend: JaduXml::AddressPresenter, class: Address
    property :address_telephone_number, as: "OfficeNumber", render_nil: true
    property :mobile_number, as: "AltPhoneNumber", render_nil: true
    property :email_address, as: "Email", render_nil: true
    property :fax_number, as: "Fax", render_nil: true
    property :contact_preference, as: "PreferredContactMethod", exec_context: :decorator, render_nil: true

    def contact_preference
      represented.contact_preference.try(:humanize)
    end
  end
end
