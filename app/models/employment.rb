class Employment < ApplicationRecord
  belongs_to :claim, optional: true
end
