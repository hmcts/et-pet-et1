class ApplicationReference < ActiveRecord::Base
  belongs_to    :claim
  before_create :assign_application_reference

  def self.generate
    hyphenate(Base32::Crockford.encode(SecureRandom.random_bytes(5)))
  end

  def self.normalize(str)
    hyphenate(str.upcase.tr('IOL', '101').gsub(/[^0-9A-Z]/, ''))
  end

  def self.hyphenate(digits)
    digits.scan(/.{1,4}/).join('-')
  end

  private

  def assign_application_reference
    self[:reference] = unique_application_reference
  end

  def unique_application_reference
    loop do
      ref = self.class.generate
      return ref unless self.class.exists?(reference: ref)
    end
  end
end
