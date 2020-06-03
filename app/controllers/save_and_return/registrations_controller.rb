module SaveAndReturn
  class RegistrationsController < ::Devise::RegistrationsController

    def new

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
      return unless current_claim && current_claim.email_address.present?

      AccessDetailsMailer.deliver_later(current_claim)
    end

    protected

    def build_resource(hash = {})
      self.resource = claim
      resource.attributes= hash
      resource
    end

    def sign_up_params
      params.require(:application_number).permit(:email_address, :password).to_h.with_indifferent_access
    end
  end
end
