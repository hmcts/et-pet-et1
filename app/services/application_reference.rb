require 'base32_pure'

class ApplicationReference
  def self.generate(length = 8)
    number = SecureRandom.hex.to_i(16)
    encoded = Base32::Crockford.encode(number)
    truncated = encoded.rjust(length, '0')[-length..-1]
    hyphenate(truncated)
  end

  def self.normalize(str)
    hyphenate(str.upcase.tr('IOL', '101').gsub(/[^0-9A-Z]/, ''))
  end

  def self.hyphenate(digits)
    digits.scan(/.{1,4}/).join('-')
  end
end
