class BeaconsController < ApplicationController
  # GET /beacons
  # GET /beacons.json
  def index
    @beacons = Beacon.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @beacons }
    end
  end

  # GET /beacons/1
  # GET /beacons/1.json
  def show
    @beacon = Beacon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @beacon }
    end
  end

  # GET /beacons/new
  # GET /beacons/new.json
  def new
    @beacon = Beacon.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @beacon }
    end
  end

  # GET /beacons/1/edit
  def edit
    @beacon = Beacon.find(params[:id])
  end

  # POST /beacons
  # POST /beacons.json
  def create
    @beacon = Beacon.new(params[:beacon])
    respond_to do |format|
      if @beacon.save
        format.html { redirect_to @beacon, notice: 'Beacon was successfully created.' }
        format.json { render json: @beacon, status: :created, location: @beacon }
      else
        format.html { render action: "new" }
        format.json { render json: @beacon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /beacons/1
  # PUT /beacons/1.json
  def update
    @beacon = Beacon.find(params[:id])

    respond_to do |format|
      if @beacon.update_attributes(params[:beacon])
        format.html { redirect_to @beacon, notice: 'Beacon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @beacon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beacons/1
  # DELETE /beacons/1.json
  def destroy
    @beacon = Beacon.find(params[:id])
    @beacon.destroy

    respond_to do |format|
      format.html { redirect_to beacons_url }
      format.json { head :no_content }
    end
  end
end
