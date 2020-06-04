module SaveAndReturn
  class SessionsController < ::Devise::SessionsController

    def create
      super
      session[:claim_reference] = current_user.reference
    end

    def user_root_path
      # @TODO Make this go to whatever page it needs to
      claim_path_for ClaimPagesManager.second_page
    end

    protected
  end
end
