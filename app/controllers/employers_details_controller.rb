class EmployersDetailsController < ApplicationController
  before_action :set_employers_detail, only: [:show, :edit, :update, :destroy]

  # GET /employers_details
  # GET /employers_details.json
  def index
    @employers_details = EmployersDetail.all
  end

  # GET /employers_details/1
  # GET /employers_details/1.json
  def show
  end

  # GET /employers_details/new
  def new
    @employers_detail = EmployersDetail.new
  end

  # GET /employers_details/1/edit
  def edit
  end

  # POST /employers_details
  # POST /employers_details.json
  def create
    @employers_detail = EmployersDetail.new(employers_detail_params)

    respond_to do |format|
      if @employers_detail.save
        format.html { redirect_to @employers_detail, notice: 'Employers detail was successfully created.' }
        format.json { render :show, status: :created, location: @employers_detail }
      else
        format.html { render :new }
        format.json { render json: @employers_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employers_details/1
  # PATCH/PUT /employers_details/1.json
  def update
    respond_to do |format|
      if @employers_detail.update(employers_detail_params)
        format.html { redirect_to @employers_detail, notice: 'Employers detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @employers_detail }
      else
        format.html { render :edit }
        format.json { render json: @employers_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employers_details/1
  # DELETE /employers_details/1.json
  def destroy
    @employers_detail.destroy
    respond_to do |format|
      format.html { redirect_to employers_details_url, notice: 'Employers detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employers_detail
      @employers_detail = EmployersDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employers_detail_params
      params.require(:employers_detail).permit(:name, :building_name_number, :street, :town_city, :county, :postcode, :telephone, :acas_certificate_number, :acas_number, :work_address_different, :another_employer_same_case, :employed_by_organisation)
    end
end
