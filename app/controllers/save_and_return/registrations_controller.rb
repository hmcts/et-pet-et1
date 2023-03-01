module SaveAndReturn
  class RegistrationsController < ::Devise::RegistrationsController
    before_action :check_session_expiry, only: [:new, :create]
    skip_before_action :require_no_authentication, only: [:new, :create]

    def new
      if session[:claim_reference].nil?
        claim = Claim.create
        session[:claim_reference] = claim.reference
      end
      super
    end

    def create
      super
      deliver_access_details
    end

    def page_manager
      @page_manager ||= ClaimPagesManager.new(resource: form_object)
    end

    def form_object
      @form_object ||= Form.for(current_step).new(claim)
    end

    def current_step
      params[:page].underscore
    end

    def claim_root_path
      # @TODO Make this go to whatever page it needs to
      claim_claimant_path
    end

    helper_method :page_manager, :form_object, :current_step

    private

    def deliver_access_details
      return unless claim && claim&.user&.email.present?

      AccessDetailsMailer.deliver_later(claim)
    end

    protected

    def translation_scope
      "save_and_return.#{controller_name}"
    end

    def after_sign_up_path_for(_resource)
      claim_path_for page_manager.forward
    end

    def sign_up_params
      params.require(:save_and_return).require(:user).permit(:email, :password, :reference).to_h.with_indifferent_access
    end

    def build_resource(*)
      super
      resource.claim = claim
    end
  end
end
