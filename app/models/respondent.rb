class Respondent < ApplicationRecord
  belongs_to :claim, optional: true
  has_many   :addresses, as: :addressable, autosave: true

  ADDRESS_ATTRIBUTES = [
    :building, :street, :locality, :county, :post_code,
    :telephone_number
  ].flat_map { |a| [a, :"#{a}="] }

  delegate(*ADDRESS_ATTRIBUTES, to: :address, prefix: true)
  delegate(*ADDRESS_ATTRIBUTES, to: :work_address, prefix: true)

  def address
    addresses.detect(&:primary?) || addresses.build(primary: true)
  end

  def work_address
    addresses.reject(&:primary?).first || addresses.build(primary: false)
  end
end
