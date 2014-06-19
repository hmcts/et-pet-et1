class Claimant < ActiveRecord::Base
  TITLES              = %i<mr mrs ms miss>.freeze
  GENDERS             = %i<male female>.freeze
  CONTACT_PREFERENCES = %i<email post fax>.freeze
end
