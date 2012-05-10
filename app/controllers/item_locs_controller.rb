class ItemLocsController < ApplicationController

  def index
    @item_info = ItemInfo.find(params[:item_info_id])
    @item_locs = @item_info.item_locs

    respond_to do |format|
      format.html { head :no_content }
      format.json { render json: @item_locs.as_json }
    end
  end

  def show
    @item_info = ItemInfo.find(params[:item_info_id])
    @item_loc = @item_info.item_locs.find(params[:id])

    respond_to do |format|
      format.html { head :no_content }
      format.json { render json: @item_loc.as_json }
    end
  end

  def create
    @item_info = ItemInfo.find(params[:item_info_id])

    respond_to do |format|
      if @item_info.item_locs.create(params[:item_loc])
        format.html { redirect_to @item_info, notice: 'Localized item information was successfully created.' }
        format.json { render json: @item_info, status: :created, location: @item_info }
      else
        format.html { render action: "new" }
        format.json { render json: @item_info.errors, status: :unprocessable_entity }
      end
    end
  end

end
