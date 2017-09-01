class Refund < ActiveRecord::Base
  include Reference
  has_secure_password validations: false
  after_initialize :generate_application_reference
  has_one :primary_claimant, -> { where primary_claimant: true },
          class_name: 'Claimant'

end
