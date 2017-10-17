class Office < ApplicationRecord
  belongs_to :claim, optional: true
end
