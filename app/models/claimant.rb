class Claimant < ActiveRecord::Base
  belongs_to :claim
  has_one :address, as: :addressable

  delegate :building, :street, :locality, :county, :post_code, :telephone_number, :country,
    :building=, :street=, :locality=, :county=, :post_code=, :telephone_number=, :country=,
    to: :address, prefix: true

  def address
    association(:address).target ||= build_address
  end
end
