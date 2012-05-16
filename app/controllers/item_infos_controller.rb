class ItemInfosController < ApplicationController

  def getitem(index)
    # Get the Accept-Language first. If it doesn't exist, default to en
    @language = ApplicationHelper.preferred_language(request.headers["Accept-Language"])
    item = ItemInfosHelper.getitembylocale(index, @language)
    return item
  end

  # GET /item_infos
  # GET /item_infos.json
  def index
    @item_infos = ItemInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @item_infos }
    end
  end

  # GET /item_infos/1
  # GET /item_infos/1.json
  def show
      respond_to do |format|
      format.html { # show.html.erb
        @item_info = ItemInfo.find(params[:id])
      }
      format.json {
        render json: getitem(params[:id])
      }
    end
  end

  # GET /item_infos/new
  # GET /item_infos/new.json
  def new
    @item_info = ItemInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item_info }
    end
  end

  # GET /item_infos/1/edit
  def edit
    @item_info = ItemInfo.find(params[:id])
  end

  # POST /item_infos
  # POST /item_infos.json
  def create
    @item_info = ItemInfo.new(params[:item_info])

    respond_to do |format|
      if @item_info.save
        format.html { redirect_to @item_info, notice: 'Item info was successfully created.' }
        format.json { render json: @item_info, status: :created, location: @item_info }
      else
        format.html { render action: "new" }
        format.json { render json: @item_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /item_infos/1
  # PUT /item_infos/1.json
  def update
    @item_info = ItemInfo.find(params[:id])

    respond_to do |format|
      if @item_info.update_attributes(params[:item_info])
        format.html { redirect_to @item_info, notice: 'Item info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_infos/1
  # DELETE /item_infos/1.json
  def destroy
    @item_info = ItemInfo.find(params[:id])
    @item_info.destroy

    respond_to do |format|
      format.html { redirect_to item_infos_url }
      format.json { head :no_content }
    end
  end

  # GET /item_infos/random
  def random
    count = ItemInfo.count
    index = rand(count) + 1
    respond_to do |format|
      format.json {
        render json: getitem(index)
      }
    end
  end
end
