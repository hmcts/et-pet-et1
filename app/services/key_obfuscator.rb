require 'base32_pure'
require 'integer_obfuscator'

# Class to obfuscate incrementing primary keys to provide a public form
# number to a claim application. As requested by Ash Berlin.

class KeyObfuscator
  def initialize(secret: Rails.application.secrets.secret_key_base)
    @obfuscator = IntegerObfuscator.new(secret)
  end

  def obfuscate(numeric)
    Base32::Crockford.encode(@obfuscator.obfuscate(numeric))
  end

  def unobfuscate(string)
    @obfuscator.unobfuscate(Base32::Crockford.decode(string).unpack('N')[0])
  end
end
