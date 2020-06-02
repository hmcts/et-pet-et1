module SaveAndReturn
  class SessionsController < ::Devise::SessionsController

    def create
      super
      return unless current_claim.present?

      session[:claim_reference] = current_claim.application_reference
    end

    def claim_root_path
      # @TODO Make this go to whatever page it needs to
      claim_claimant_path
    end
  end
end
