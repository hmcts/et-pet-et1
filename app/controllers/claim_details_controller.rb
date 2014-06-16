class ClaimDetailsController < ApplicationController
  before_action :set_claim_detail, only: [:show, :edit, :update, :destroy]

  # GET /claim_details
  # GET /claim_details.json
  def index
    @claim_details = ClaimDetail.all
  end

  # GET /claim_details/1
  # GET /claim_details/1.json
  def show
  end

  # GET /claim_details/new
  def new
    @claim_detail = ClaimDetail.new
  end

  # GET /claim_details/1/edit
  def edit
  end

  # POST /claim_details
  # POST /claim_details.json
  def create
    @claim_detail = ClaimDetail.new(claim_detail_params)

    respond_to do |format|
      if @claim_detail.save
        format.html { redirect_to @claim_detail, notice: 'Claim detail was successfully created.' }
        format.json { render :show, status: :created, location: @claim_detail }
      else
        format.html { render :new }
        format.json { render json: @claim_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /claim_details/1
  # PATCH/PUT /claim_details/1.json
  def update
    respond_to do |format|
      if @claim_detail.update(claim_detail_params)
        format.html { redirect_to @claim_detail, notice: 'Claim detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @claim_detail }
      else
        format.html { render :edit }
        format.json { render json: @claim_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /claim_details/1
  # DELETE /claim_details/1.json
  def destroy
    @claim_detail.destroy
    respond_to do |format|
      format.html { redirect_to claim_details_url, notice: 'Claim detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_claim_detail
      @claim_detail = ClaimDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def claim_detail_params
      params.require(:claim_detail).permit(:unfairly_dismissed, :discrimination, :pay, :whistleblowing_claim, :type_of_claims, :other_complaints, :want_if_claim_successful, :compensation_other_outcome, :similar_claims, :similar_claims_names, :additional_information, :rtf_file)
    end
end
