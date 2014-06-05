class YourrepresentativesController < ApplicationController
  before_action :set_yourrepresentative, only: [:show, :edit, :update, :destroy]

  # GET /yourrepresentatives
  # GET /yourrepresentatives.json
  def index
    @yourrepresentatives = Yourrepresentative.all
  end

  # GET /yourrepresentatives/1
  # GET /yourrepresentatives/1.json
  def show
  end

  # GET /yourrepresentatives/new
  def new
    @yourrepresentative = Yourrepresentative.new
  end

  # GET /yourrepresentatives/1/edit
  def edit
  end

  # POST /yourrepresentatives
  # POST /yourrepresentatives.json
  def create
    @yourrepresentative = Yourrepresentative.new(yourrepresentative_params)

    respond_to do |format|
      if @yourrepresentative.save
        format.html { redirect_to @yourrepresentative, notice: 'Yourrepresentative was successfully created.' }
        format.json { render :show, status: :created, location: @yourrepresentative }
      else
        format.html { render :new }
        format.json { render json: @yourrepresentative.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /yourrepresentatives/1
  # PATCH/PUT /yourrepresentatives/1.json
  def update
    respond_to do |format|
      if @yourrepresentative.update(yourrepresentative_params)
        format.html { redirect_to @yourrepresentative, notice: 'Yourrepresentative was successfully updated.' }
        format.json { render :show, status: :ok, location: @yourrepresentative }
      else
        format.html { render :edit }
        format.json { render json: @yourrepresentative.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /yourrepresentatives/1
  # DELETE /yourrepresentatives/1.json
  def destroy
    @yourrepresentative.destroy
    respond_to do |format|
      format.html { redirect_to yourrepresentatives_url, notice: 'Yourrepresentative was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_yourrepresentative
      @yourrepresentative = Yourrepresentative.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def yourrepresentative_params
      params.require(:yourrepresentative).permit(:type_of_representative, :representative_organisation, :representative_name, :building_number_name, :street, :town_city, :county, :postcode, :telephone, :mobile, :email, :dx_number)
    end
end
