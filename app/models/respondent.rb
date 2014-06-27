class Respondent < ActiveRecord::Base
  belongs_to :claim
  has_many :addresses, as: :addressable
end
