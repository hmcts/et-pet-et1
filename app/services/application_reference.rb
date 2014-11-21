require 'base32_pure'

class ApplicationReference
  def self.generate
    hyphenate(Base32::Crockford.encode(SecureRandom.random_bytes(5)))
  end

  def self.normalize(str)
    hyphenate(str.upcase.tr('IOL', '101').gsub(/[^0-9A-Z]/, ''))
  end

  def self.hyphenate(digits)
    digits.scan(/.{1,4}/).join('-')
  end
end
