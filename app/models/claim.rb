class Claim < ActiveRecord::Base
  has_secure_password validations: false

  validates :password, confirmation: true
  validates :password_confirmation,
    presence: { if: -> { attribute_changed? :password_digest } }

  has_many :claimants
  accepts_nested_attributes_for :claimants

  def reference
    KeyObfuscator.new.obfuscate(id)
  end

  def to_param
    reference
  end

  class << self
    def find_by_reference(reference)
      find KeyObfuscator.new.unobfuscate(reference)
    end
  end
end
