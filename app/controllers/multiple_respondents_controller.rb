class MultipleRespondentsController < ClaimsController
  def show
    resource.secondary_respondents.build if resource.secondary_respondents.empty?
  end

  def update
    resource.assign_attributes params[current_step].permit!

    if params[:commit] == "claims.#{current_step}.add_fields"
      resource.secondary_respondents.build

      render :show
    elsif resource.save
      redirect_to next_page
    else
      render action: :show
    end
  end
end
