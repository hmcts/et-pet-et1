class DiversitiesController < ApplicationController
  layout "diversities/application"

  def index; end

  def new
    @diversity = Diversity.new
  end

  def create
    @diversity = Diversity.new(diversity_params)
    if @diversity.save
      redirect_to diversity_path(@diversity)
    else
      render :new
    end
  end

  def show
    diversity
  end

  def edit
    diversity
    render :edit
  end

  def submit
    @diversity = Diversity.find(params[:diversity_id])

  end

  private

  def diversity_params
    params.require(:diversity).
      permit(:claim_type, :sex, :sexual_identity, :gender,
        :gender_at_birth, :ethnicity, :ethnicity_subgroup, :age_group,
        :relationship, :religion, :caring_responsibility, :pregnancy,
        :disability).merge(ethnicity_subgroup: ethnicity_subgroup)
  end

  def diversity
    @diversity ||= Diversity.find(params[:id])
  end

  def ethnicity_subgroup
    subgroups = params[:diversity].keys.select{|a| a.include? 'ethnicity_subgroup_'}
    subgroups.map {|key| params[:diversity][key] if params[:diversity][key].present?}.compact.first
  end
end
