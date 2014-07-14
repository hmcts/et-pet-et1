class Respondent < ActiveRecord::Base
  belongs_to :claim
  has_many :addresses, as: :addressable

  ADDRESS_ATTRIBUTES = %i<building street locality county post_code
                          telephone_number>.flat_map { |a| [a, :"#{a}="] }

  delegate *ADDRESS_ATTRIBUTES, to: :address, prefix: true
  delegate *ADDRESS_ATTRIBUTES, to: :work_address, prefix: true

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
