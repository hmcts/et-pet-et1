class Payment < ActiveRecord::Base
  belongs_to :claim
end
