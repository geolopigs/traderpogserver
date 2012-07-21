class FlyerLocsController < ApplicationController

  def index
    respond_to do |format|
      begin
        @flyer_info = FlyerInfo.find(params[:flyer_info_id])
        @flyer_locs = @flyer_info.flyer_locs
        format.html { head :no_content }
        format.json { render json: @flyer_locs.as_json }
      rescue
        @errormsg = { "errormsg" => "Data incorrect" }
        format.html { render 'posts/error', status: :forbidden }
        format.json { render json: @errormsg, status: :forbidden }
      end
    end
  end

  def show
    respond_to do |format|
      begin
        @flyer_info = FlyerInfo.find(params[:flyer_info_id])
        @flyer_loc = @flyer_info.flyer_locs.find(params[:id])
        format.html { head :no_content }
        format.json { render json: @flyer_loc.as_json }
      rescue
        @errormsg = { "errormsg" => "Data incorrect" }
        format.html { render 'posts/error', status: :forbidden }
        format.json { render json: @errormsg, status: :forbidden }
      end
    end
  end

  def create
    respond_to do |format|
      begin
        @flyer_info = FlyerInfo.find(params[:flyer_info_id])
        format.html {
          if @flyer_info.flyer_locs.create(params[:flyer_loc])
            redirect_to @flyer_info, notice: 'Localized flyer information was successfully created.'
          else
            render action: "new"
          end
        }
        format.json {
          if ApplicationHelper.validate_key(request.headers["Validation-Key"])
            @flyer_loc = @flyer_info.flyer_locs.create(params[:flyer_loc])
            if @flyer_loc.valid?
              render json: @flyer_loc.as_json(:only => [:id])
            else
              render json: @flyer_loc.errors, status: :unprocessable_entity
            end
          else
            @errormsg = { "errormsg" => "Data incorrect" }
            render json: @errormsg, status: :forbidden
          end
        }
      rescue
        @errormsg = { "errormsg" => "Data incorrect" }
        format.html { render 'posts/error', status: :forbidden }
        format.json { render json: @errormsg, status: :forbidden }
      end
    end
  end
end
