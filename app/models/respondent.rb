class Respondent < ActiveRecord::Base
  belongs_to :claim
  has_many :addresses, as: :addressable

  delegate :building, :street, :locality, :county, :post_code, :telephone_number,
    :building=, :street=, :locality=, :county=, :post_code=, :telephone_number=,
    to: :address, prefix: true

  delegate :building, :street, :locality, :county, :post_code, :telephone_number,
    :building=, :street=, :locality=, :county=, :post_code=, :telephone_number=,
    to: :work_address, prefix: true

  def address
    addresses.first
  end

  def work_address
    addresses.second
  end

  def addresses
    association(:addresses).tap do |p|
      2.times { p.build } if p.empty?
    end
  end
end
