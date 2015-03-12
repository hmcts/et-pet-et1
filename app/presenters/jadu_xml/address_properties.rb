module JaduXml
  module AddressProperties
    extend ActiveSupport::Concern

    included do
      property :building,   as: 'Line'
      property :street,     as: 'Street'
      property :locality,   as: 'Town'
      property :county,     as: 'County'
      property :post_code,  as: 'Postcode'
    end
  end
end
