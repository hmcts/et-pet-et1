module JaduXml
  class RespondentPresenter < XmlPresenter
    property :primary_respondent, as: "GroupContact"
    property :name, as: "Name"
    property :address, extend: JaduXml::AddressPresenter, class: Address
    property :work_address_telephone_number, as: "OfficeNumber", render_nil: true
    property :address_telephone_number, as: "PhoneNumber", render_nil: true
    property :acas, extend: JaduXml::AcasPresenter, exec_context: :decorator

    def acas
      JaduXml::Acas.new(represented)
    end
  end
end
