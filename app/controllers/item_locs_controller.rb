require 'logging'

class ItemLocsController < ApplicationController

  include Logging

  def index
    respond_to do |format|
      begin
        @item_info = ItemInfo.find(params[:item_info_id])
        @item_locs = @item_info.item_locs
        format.html { head :no_content }
        format.json { render json: @item_locs.as_json }
      rescue
        @errormsg = { "errormsg" => "Data incorrect" }
        format.html { render 'posts/error', status: :forbidden }
        format.json {
          create_error(:unprocessable_entity, :get, params[:item_loc], "Item info not found")
        }
      end
    end
  end

  def show
    respond_to do |format|
      begin
        @item_info = ItemInfo.find(params[:item_info_id])
        @item_loc = @item_info.item_locs.find(params[:id])
        format.html { head :no_content }
        format.json { render json: @item_loc.as_json }
      rescue
        @errormsg = { "errormsg" => "Data incorrect" }
        format.html { render 'posts/error', status: :forbidden }
        format.json {
          create_error(:unprocessable_entity, :get, params[:item_loc], "Item info not found")
        }
      end
    end
  end

  def create
    respond_to do |format|
      begin
        @item_info = ItemInfo.find(params[:item_info_id])
        format.html {
          if @item_info.item_locs.create(params[:item_loc])
            GameInfoHelper.updateTime
            redirect_to @item_info, notice: 'Localized item information was successfully created.'
          else
            render action: "new"
          end
        }
        format.json {
          if ApplicationHelper.validate_key(request.headers["Validation-Key"])
            @item_loc = @item_info.item_locs.create(params[:item_loc])
            if @item_loc.valid?
              GameInfoHelper.updateTime
              render json: @item_loc.as_json(:only => [:id])
            else
              render json: @item_loc.errors, status: :unprocessable_entity
            end
          else
            create_error(:forbidden, :post, params[:item_loc], "Data incorrect")
          end
        }
      rescue
        @errormsg = { "errormsg" => "Data incorrect" }
        format.html { render 'posts/error', status: :forbidden }
        format.json {
          create_error(:unprocessable_entity, :get, params[:item_loc], "Item info not found")
        }
      end
    end
  end

end
