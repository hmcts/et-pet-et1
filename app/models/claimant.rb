class Claimant < ActiveRecord::Base
  belongs_to :claim
  has_one :address, as: :addressable, autosave: true

  delegate :building, :street, :locality, :county, :post_code, :telephone_number, :country,
    :building=, :street=, :locality=, :county=, :post_code=, :telephone_number=, :country=,
    to: :address, prefix: true

  def address
    super || build_address
  end

  def name
    first_name + ' ' + last_name
  end
end
