module JaduXml
  class RepresentativePresenter < XmlPresenter
    property :name, as: "Name"
    property :address, extend: JaduXml::AddressPresenter, class: Address
    property :address_telephone_number, as: "OfficeNumber", render_nil: true
    property :mobile_number, as: "AltPhoneNumber", render_nil: true
    property :email_address, as: "Email", render_nil: true
    property :claimant_or_respondent, as: "ClaimantOrRespondent", exec_context: :decorator

    def claimant_or_respondent
      "C"
    end
  end
end
