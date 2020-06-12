module SaveAndReturn
  class PasswordsController < ::Devise::PasswordsController

    protected

    def translation_scope
      "save_and_return.#{controller_name}"
    end
  end
end
