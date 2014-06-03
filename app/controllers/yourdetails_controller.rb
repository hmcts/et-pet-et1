class YourdetailsController < ApplicationController
  before_action :set_yourdetail, only: [:show, :edit, :update, :destroy]

  # GET /yourdetails
  # GET /yourdetails.json
  def index
    @yourdetails = Yourdetail.all
  end

  # GET /yourdetails/1
  # GET /yourdetails/1.json
  def show
  end

  # GET /yourdetails/new
  def new
    @yourdetail = Yourdetail.new
  end

  # GET /yourdetails/1/edit
  def edit
  end

  # POST /yourdetails
  # POST /yourdetails.json
  def create
    @yourdetail = Yourdetail.new(yourdetail_params)

    respond_to do |format|
      if @yourdetail.save
        format.html { redirect_to @yourdetail, notice: 'Yourdetail was successfully created.' }
        format.json { render :show, status: :created, location: @yourdetail }
      else
        format.html { render :new }
        format.json { render json: @yourdetail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /yourdetails/1
  # PATCH/PUT /yourdetails/1.json
  def update
    respond_to do |format|
      if @yourdetail.update(yourdetail_params)
        format.html { redirect_to @yourdetail, notice: 'Yourdetail was successfully updated.' }
        format.json { render :show, status: :ok, location: @yourdetail }
      else
        format.html { render :edit }
        format.json { render json: @yourdetail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /yourdetails/1
  # DELETE /yourdetails/1.json
  def destroy
    @yourdetail.destroy
    respond_to do |format|
      format.html { redirect_to yourdetails_url, notice: 'Yourdetail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_yourdetail
      @yourdetail = Yourdetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def yourdetail_params
      params.require(:yourdetail).permit(:title, :first_name, :last_name, :gender, :date_of_birth, :building_number_name, :street, :town_city, :county, :postcode, :telephone, :mobile, :contact_method, :disability, :help_with_fees, :reprasentative)
    end
end
