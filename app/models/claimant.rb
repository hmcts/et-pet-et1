class Claimant < ActiveRecord::Base
  belongs_to :claim
  has_one :address, as: :addressable
end
