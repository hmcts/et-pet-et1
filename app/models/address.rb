class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true, optional: true

  def empty?
    building.nil? && street.nil? && locality.nil? && county.nil? && post_code.nil?
  end
end
