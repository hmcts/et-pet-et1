module JaduXml
  class AddressPresenter < XmlPresenter
    property :number, as: "Number", exec_context: :decorator
    property :name, as: "Name", exec_context: :decorator
    property :street, as: "Street"
    property :locality, as: "Town"
    property :county, as: "County"
    property :post_code, as: "Postcode"

    delegate :building, to: :represented

    def number
      building_split.first
    end

    def name
      building_split.last
    end

    private def building_split
      @building_split ||= building.scan(/(^[0-9]{0,4})(.*)/).flatten.map(&:strip)
    end
  end
end
