module JaduXml
  module AddressProperties
    extend ActiveSupport::Concern

    included do
      property :building,   as: 'Line',     render_nil: true
      property :street,     as: 'Street',   render_nil: true
      property :locality,   as: 'Town',     render_nil: true
      property :county,     as: 'County',   render_nil: true
      property :post_code,  as: 'Postcode', render_nil: true
    end
  end
end
