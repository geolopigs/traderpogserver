class FlyerInfosController < ApplicationController
  # GET /flyer_infos
  # GET /flyer_infos.json
  def index
    @flyer_infos = FlyerInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @flyer_infos }
    end
  end

  # GET /flyer_infos/1
  # GET /flyer_infos/1.json
  def show
    @flyer_info = FlyerInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @flyer_info }
    end
  end

  # GET /flyer_infos/new
  # GET /flyer_infos/new.json
  def new
    @flyer_info = FlyerInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @flyer_info }
    end
  end

  # GET /flyer_infos/1/edit
  def edit
    @flyer_info = FlyerInfo.find(params[:id])
  end

  # POST /flyer_infos
  # POST /flyer_infos.json
  def create
    @flyer_info = FlyerInfo.new(params[:flyer_info])

    respond_to do |format|
      if @flyer_info.save
        format.html { redirect_to @flyer_info, notice: 'Flyer info was successfully created.' }
        format.json { render json: @flyer_info, status: :created, location: @flyer_info }
      else
        format.html { render action: "new" }
        format.json { render json: @flyer_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /flyer_infos/1
  # PUT /flyer_infos/1.json
  def update
    @flyer_info = FlyerInfo.find(params[:id])

    respond_to do |format|
      if @flyer_info.update_attributes(params[:flyer_info])
        format.html { redirect_to @flyer_info, notice: 'Flyer info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @flyer_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flyer_infos/1
  # DELETE /flyer_infos/1.json
  def destroy
    @flyer_info = FlyerInfo.find(params[:id])
    @flyer_info.destroy

    respond_to do |format|
      format.html { redirect_to flyer_infos_url }
      format.json { head :no_content }
    end
  end
end
