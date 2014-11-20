require 'base32_pure'
require 'integer_obfuscator'

# Class to obfuscate incrementing primary keys to provide a public form
# number to a claim application. As requested by Ash Berlin.

class KeyObfuscator
  def initialize(secret: Rails.application.secrets.app_ref_secret_key)
    @obfuscator = IntegerObfuscator.new(secret)
  end

  def obfuscate(numeric)
    format(encode(@obfuscator.obfuscate(numeric)))
  end

  def unobfuscate(string)
    @obfuscator.unobfuscate(decode(clean(string)))
  end

  private

  def encode(number)
    Base32::Crockford.encode(number)
  end

  def decode(string)
    Base32::Crockford.decode(string).unpack('N')[0]
  end

  def format(digits)
    digits.rjust(7, '0').scan(/\A.{3}|.{4}/).join('-')
  end

  def clean(string)
    string.upcase.gsub(/\A[0O]|[^0-9A-Z]/, '')
  end
end
