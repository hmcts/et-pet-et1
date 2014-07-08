class Representative < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :claim
  has_one :address, as: :addressable

  delegate :building, :street, :locality, :county, :post_code, :telephone_number,
    :building=, :street=, :locality=, :county=, :post_code=, :telephone_number=,
    to: :address, prefix: true

  def address
    association(:address).target ||= build_address
  end
end
