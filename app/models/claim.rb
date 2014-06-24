class Claim < ActiveRecord::Base
  has_secure_password validations: false

  has_many :claimants
  has_one  :representative

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
