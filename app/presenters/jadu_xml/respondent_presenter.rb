module JaduXml
  class RespondentPresenter < XmlPresenter
    property :primary_respondent, as: 'GroupContact'
    property :name, as: 'Name'
    property :address, extend: JaduXml::AddressPresenter, class: Address
    property :work_address_telephone_number, as: 'OfficeNumber', render_nil: true
    property :address_telephone_number, as: 'PhoneNumber', render_nil: true
    property :acas, extend: JaduXml::AcasPresenter, exec_context: :decorator
    property :work_address, extend: JaduXml::AltAddressPresenter, class: Address
    property :alt_phone_number, as: 'AltPhoneNumber', render_nil: true, exec_context: :decorator

    def acas
      represented
    end

    def alt_phone_number
      # weird schema requires 3 phone numbers - as the AltAddress
      # is the work address we use the work tel as the AltPhoneNumber
      # representable removes the duplicated property in this instance
      # so this method just acts as an alias.

      represented.work_address_telephone_number
    end
  end
end
