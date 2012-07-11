class ItemInfosController < ApplicationController

  # @param [Object] index
  def getitem(index)
    # Get the Accept-Language first. If it doesn't exist, default to en
    @language = ApplicationHelper.preferred_language(request.headers["Accept-Language"])
    @item_info = ItemInfo.find(params[:id])
    @item_loc = ItemInfosHelper.getitemloc(@item_info, @language)
    @item_info.as_json.merge(@item_loc.first.as_json)
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
          redirect_to @item_info, notice: 'Item info was successfully created.'
        else
          render action: "new"
        end
      }
      format.json {
        if ApplicationHelper.validate_key(request.headers["Validation-Key"])
          @item_info = ItemInfo.new(params[:item_info])
          if @item_info.save
            render json: @item_info.as_json(:only => [:id])
          else
            render json: @item_info.errors, status: :unprocessable_entity
          end
        else
          @errormsg = { "errormsg" => "Data incorrect" }
          render json: @errormsg, status: :forbidden
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
          redirect_to @item_info, notice: 'Item info was successfully updated.'
        else
          render action: "edit"
        end
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
        redirect_to item_infos_url
      }
    end
  end

  # GET /item_infos/tier
  def tier
    @tier = request.headers["Item-Tier"]
    @item_infos = ItemInfo.where("tier = ?", Integer(@tier)).select("id, price, supplymax, supplyrate, multiplier")
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
