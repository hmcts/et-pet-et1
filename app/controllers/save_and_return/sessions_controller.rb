module SaveAndReturn
  class SessionsController < ::Devise::SessionsController
    prepend_before_action :check_session_expiry, only: [:new, :create]

    def create
      self.resource = warden.authenticate!(auth_options)
      resource.validate_after_login
      if current_user.errors.empty?
        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        respond_with resource, location: after_sign_in_path_for(resource)
        store_claim_in_session
      else
        render 'new'
      end
    end

    def user_root_path
      claim_path_for ClaimPagesManager.second_page
    end

    protected

    def translation_scope
      "save_and_return.#{controller_name}"
    end

    private

    def store_claim_in_session
      session[:claim_reference] = current_user.reference
    end

    def check_session_expiry
      return unless session[:expires_in]

      return unless Time.current > session[:expires_in]

      logout_application
    end

    def logout_application
      claim&.create_event Event::LOGOUT, actor: 'user'
      reset_session
    end
  end
end
