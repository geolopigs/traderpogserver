require 'logging'

class ItemInfosController < ApplicationController

  include Logging

  # @param [Object] index
  def getitem(index)
    # Get the Accept-Language first. If it doesn't exist, default to en
    @language = ApplicationHelper.preferred_language(request.headers["Accept-Language"])
    @item_info = ItemInfo.find(index, :select => "id, img, price, supplymax, supplyrate, multiplier, tier, disabled")
    @item_loc = ItemInfosHelper.getitemloc(@item_info, @language)
    @item_info.as_json.merge(@item_loc.first.as_json)
  end

  # GET /item_infos
  # GET /item_infos.json
  def index
    @item_infos = ItemInfo.all(:select => "id, img, price, supplymax, supplyrate, multiplier, tier, disabled")
    @language = ApplicationHelper.preferred_language(request.headers["Accept-Language"])

    @complete_items = @item_infos.collect { |item_info|
      item_info.as_json.merge(ItemInfosHelper.getitemloc(item_info, @language).first.as_json)
    }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @complete_items }
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
    respond_to do |format|
      format.html {  # new.html.erb
        @item_info = ItemInfo.new
      }
    end
  end

  # GET /item_infos/1/edit
  def edit
    @item_info = ItemInfo.find(params[:id])
  end

  # POST /item_infos
  # POST /item_infos.json
  def create
    respond_to do |format|
      format.html {
        @item_info = ItemInfo.new(params[:item_info])
        if @item_info.save
          GameInfoHelper.updateTime
          redirect_to @item_info, notice: 'Item info was successfully created.'
        else
          render action: "new"
        end
      }
      format.json {
        if ApplicationHelper.validate_key(request.headers["Validation-Key"])
          @item_info = ItemInfo.new(params[:item_info])
          if @item_info.save
            GameInfoHelper.updateTime
            render json: @item_info.as_json(:only => [:id])
          else
            create_error(:unprocessable_entity, :post, params[:item_info], @item_info.errors)
          end
        else
          create_error(:forbidden, :post, params[:item_info], "Data incorrect")
        end
      }
    end
  end

  # PUT /item_infos/1
  # PUT /item_infos/1.json
  def update
    # JSON is not allowed to modify item_infos. Must be done through the website.
    respond_to do |format|
      format.html {
        @item_info = ItemInfo.find(params[:id])
        if @item_info.update_attributes(params[:item_info])
          GameInfoHelper.updateTime
          redirect_to @item_info, notice: 'Item info was successfully updated.'
        else
          render action: "edit"
        end
      }
      format.json {
        create_error(:forbidden, :put, params[:item_info], "Data incorrect")
      }
    end
  end

  # DELETE /item_infos/1
  # DELETE /item_infos/1.json
  def destroy
    # JSON is not allowed to destroy item_infos. Must be done through the website.
    respond_to do |format|
      format.html {
        @item_info = ItemInfo.find(params[:id])
        @item_info.destroy
        GameInfoHelper.updateTime
        redirect_to item_infos_url
      }
      format.json {
        create_error(:forbidden, :put, params[:item_info], "Data incorrect")
      }
    end
  end

  # GET /item_infos/tier
  def tier
    @tier = request.headers["Item-Tier"]
    @item_infos = ItemInfo.where("tier = ?", Integer(@tier)).select("id, img, price, supplymax, supplyrate, multiplier, tier, disabled")
    @language = ApplicationHelper.preferred_language(request.headers["Accept-Language"])

    @tiered_items = @item_infos.collect { |item_info|
      item_info.as_json.merge(ItemInfosHelper.getitemloc(item_info, @language).first.as_json)
    }

    respond_to do |format|
      format.json {
        render json: @tiered_items.as_json
      }
    end
  end
end
