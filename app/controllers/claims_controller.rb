class ClaimsController < ApplicationController
  def new
    @claim = Claim.new
  end

  def create
    @claim = Claim.create
    session[:claim] = @claim.id
  end

  def update
    binding.pry

    if claim.update claim_params
      session_manager.perform!
      redirect_to claim_path(@claim)
    else
      render action: :show
    end
  end

  private

  helper_method def session_manager
    @session_manager ||= ClaimSessionTransitionManager.new(params: params, session: session)
  end

  helper_method def claim
    @claim ||= Claim.find_by_reference(params[:id]).tap do |c|
      c.claimants.first || c.claimants.build
    end
  end

  def claim_params
    params.require(:claim).permit :password, :password_confirmation,
      claimants_attributes:[
        :title, :first_name, :last_name, :gender, :date_of_birth, :telephone_number,
        :mobile_number, :contact_preference, :email_address, :has_special_needs,
        :fax_number, :special_needs, :has_representative, address_attributes: [
          :building, :street, :locality, :county, :post_code
        ]
      ]
  end
end
