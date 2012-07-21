class FlyerPathsController < ApplicationController
  # GET /flyer_paths
  # GET /flyer_paths.json
  def index
    @flyer_paths = FlyerPath.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @flyer_paths }
    end
  end

  # GET /flyer_paths/1
  # GET /flyer_paths/1.json
  def show
    @flyer_path = FlyerPath.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @flyer_path }
    end
  end

  # GET /flyer_paths/new
  # GET /flyer_paths/new.json
  def new
    @flyer_path = FlyerPath.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @flyer_path }
    end
  end

  # GET /flyer_paths/1/edit
  def edit
    @flyer_path = FlyerPath.find(params[:id])
  end

  # POST /flyer_paths
  # POST /flyer_paths.json
  def create
    @flyer_path = FlyerPath.new(params[:flyer_path])

    respond_to do |format|
      if @flyer_path.save
        format.html { redirect_to @flyer_path, notice: 'Flyer path was successfully created.' }
        format.json { render json: @flyer_path, status: :created, location: @flyer_path }
      else
        format.html { render action: "new" }
        format.json { render json: @flyer_path.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /flyer_paths/1
  # PUT /flyer_paths/1.json
  def update
    @flyer_path = FlyerPath.find(params[:id])

    respond_to do |format|
      if @flyer_path.update_attributes(params[:flyer_path])
        format.html { redirect_to @flyer_path, notice: 'Flyer path was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @flyer_path.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flyer_paths/1
  # DELETE /flyer_paths/1.json
  def destroy
    @flyer_path = FlyerPath.find(params[:id])
    @flyer_path.destroy

    respond_to do |format|
      format.html { redirect_to flyer_paths_url }
      format.json { head :no_content }
    end
  end
end
