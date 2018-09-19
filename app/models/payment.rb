class Payment < ApplicationRecord
  belongs_to :claim, optional: true
end
