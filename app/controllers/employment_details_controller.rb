class EmploymentDetailsController < ApplicationController
  before_action :set_employment_detail, only: [:show, :edit, :update, :destroy]

  # GET /employment_details
  # GET /employment_details.json
  def index
    @employment_details = EmploymentDetail.all
  end

  # GET /employment_details/1
  # GET /employment_details/1.json
  def show
  end

  # GET /employment_details/new
  def new
    @employment_detail = EmploymentDetail.new
  end

  # GET /employment_details/1/edit
  def edit
  end

  # POST /employment_details
  # POST /employment_details.json
  def create
    @employment_detail = EmploymentDetail.new(employment_detail_params)

    respond_to do |format|
      if @employment_detail.save
        format.html { redirect_to @employment_detail, notice: 'Employment detail was successfully created.' }
        format.json { render :show, status: :created, location: @employment_detail }
      else
        format.html { render :new }
        format.json { render json: @employment_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employment_details/1
  # PATCH/PUT /employment_details/1.json
  def update
    respond_to do |format|
      if @employment_detail.update(employment_detail_params)
        format.html { redirect_to @employment_detail, notice: 'Employment detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @employment_detail }
      else
        format.html { render :edit }
        format.json { render json: @employment_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employment_details/1
  # DELETE /employment_details/1.json
  def destroy
    @employment_detail.destroy
    respond_to do |format|
      format.html { redirect_to employment_details_url, notice: 'Employment detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employment_detail
      @employment_detail = EmploymentDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employment_detail_params
      params.require(:employment_detail).permit(:job_title, :start_date, :hours_worked, :pay_before_tax, :pay_before_tax_frequency, :take_home_pay, :take_home_pay_frequency, :pension_scheme, :details_of_benefit, :current_situation)
    end
end
