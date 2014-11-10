class MultiplesController < ClaimsController
  def update
    resource.assign_attributes params[current_step]

    if params[:commit] == t("claims.#{current_step}.add_fields")
      resource.build_child

      render :show
    else
      super
    end
  end
end
