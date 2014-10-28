class Representative < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :claim
  has_one :address, as: :addressable, autosave: true

  delegate :building, :street, :locality, :county, :post_code, :telephone_number,
    :building=, :street=, :locality=, :county=, :post_code=, :telephone_number=,
    to: :address, prefix: true

  def address
    super || build_address
  end
end
