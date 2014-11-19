require 'base32_pure'

class ApplicationReference
  def self.generate(length = 8)
    number = SecureRandom.hex.to_i(16)
    encoded = Base32::Crockford.encode(number)
    encoded[0, length].rjust(length, '0')
  end

  def self.normalize(str)
    str.upcase.tr('IOL', '101')
  end
end
