module JaduXml
  class AddressPresenter < XmlPresenter
    property :building, as: "Line"
    property :street, as: "Street"
    property :locality, as: "Town"
    property :county, as: "County"
    property :post_code, as: "Postcode"
  end
end
