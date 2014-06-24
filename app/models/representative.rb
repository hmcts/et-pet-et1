class Representative < ActiveRecord::Base
  self.inheritance_column = nil
  
  belongs_to :claim
  has_one :address, as: :addressable
end
