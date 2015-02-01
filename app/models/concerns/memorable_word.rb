module MemorableWord
  extend ActiveSupport::Concern

  included do
    has_secure_password validations: false

    def authenticate(password)
      password_digest? && super
    end
  end
end
