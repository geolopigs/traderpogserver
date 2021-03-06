require 'logging'
require 'user_leaderboards_helper'

class FlyerPathsController < ApplicationController

  include Logging
  include UserLeaderboardsHelper

  def index
    @user = User.find(params[:user_id])
    @userflyer = @user.user_flyers.find(params[:user_flyer_id])
    pathscount = request.headers["Flyer-Paths-Count"]
    if pathscount == 0
      pathscount = 1
    end

    if ApplicationHelper.validate_key(request.headers["Validation-Key"])
      # this is a test response, don't send the created_at field
      path = @userflyer.flyer_paths.select("id, post1, post2, longitude1, longitude2, latitude1, latitude2, storms, stormed, item_info_id, num_items, price, done")
    else
      path = @userflyer.flyer_paths.select("id, created_at, post1, post2, longitude1, longitude2, latitude1, latitude2, storms, stormed, item_info_id, num_items, price, done")
    end

    respond_to do |format|
      format.html { head :no_content }
      format.json { render json: path.as_json }
    end
  end

  def show
    @user = User.find(params[:user_id])
    @userflyer = @user.user_flyers.find(params[:user_flyer_id])

    if ApplicationHelper.validate_key(request.headers["Validation-Key"])
      # this is a test response, don't send the created_at field
      path = @userflyer.flyer_paths(params[:id]).select("id, post1, post2, longitude1, longitude2, latitude1, latitude2, storms, stormed, item_info_id, num_items, price, done")
    else
      path = @userflyer.flyer_paths(params[:id]).select("id, created_at, post1, post2, longitude1, longitude2, latitude1, latitude2, storms, stormed, item_info_id, num_items, price, done")
    end

    respond_to do |format|
      format.html { head :no_content }
      format.json { render json: path.as_json }
    end
  end

  def create
    @user = User.find(params[:user_id])
    @userflyer = @user.user_flyers.find(params[:user_flyer_id])
    post1_enabled = (!params[:post1] || !(Post.find(params[:post1]).disabled))
    post2_enabled = (!params[:post2] || !(Post.find(params[:post2]).disabled))

    respond_to do |format|
      if (post1_enabled && post2_enabled)
        flyer_path = @userflyer.flyer_paths.create(params[:flyer_path])
        if flyer_path.valid?
          format.html { redirect_to @user, notice: 'Flyer path was successfully created.' }
          format.json {
            log_event(:flyer_path, :create, flyer_path.as_json)
            if ApplicationHelper.validate_key(request.headers["Validation-Key"])
              # this is a test response, don't send the created_at field
              render json: flyer_path.as_json(:only => [:id])
            else
              render json: flyer_path.as_json(:only => [:id, :created_at])
            end
          }
        else
          format.html { render action: "new" }
          format.json {
            create_error(:unprocessable_entity, :post, params[:flyer_path], flyer_path.errors)
          }
        end
      else
        @errormsg = { "errormsg" => "Post not found" }
        format.html { render 'posts/error', status: :not_found }
        format.json {
          create_error(:unprocessable_entity, :post, params[:flyer_path], "Legitimate post or coordinates missing from flyer path")
        }
      end
    end
  end

  def update
    @user = User.find(params[:user_id])
    @flyer_path = FlyerPath.find(params[:id])

    respond_to do |format|
      if @flyer_path.update_attributes(params[:flyer_path])
        format.html { redirect_to @user, notice: 'Flyer path was successfully updated.' }
        format.json {
          log_event(:flyer_path, :update, @flyer_path.as_json)
          render json: @flyer_path.as_json(:only => [:id])
        }
      else
        format.html { render action: "edit" }
        format.json {
          create_error(:unprocessable_entity, :put, params[:flyer_path], @flyer_path.errors)
        }
      end
    end
  end

  def destroy
    respond_to do |format|
      format.html {
        @user = User.find(params[:user_id])
        @flyer_path = FlyerPath.find(params[:id])
        @flyer_path.destroy
        redirect_to @user
      }
      format.json {
        create_error(:forbidden, :destroy, params[:flyer_path], "Data incorrect")
      }
    end
  end

  # PUT /users/*/user_flyers/*/flyer_paths/setdone
  def setdone
    respond_to do |format|
      format.json {
        begin
          @user = User.find(params[:user_id])
          @user_flyer = @user.user_flyers.find(params[:user_flyer_id])
          @latest_path = @user_flyer.flyer_paths.order("created_at DESC").first

          if !(@latest_path.done)
            # validate this is the right flyer path
            post1_valid = ((params[:post1] && @latest_path.post1 &&(Integer(params[:post1]) == Integer(@latest_path.post1))) ||
                (!params[:post1] && (params[:longitude1].to_f.round(3) == @latest_path.longitude1.to_f.round(3)) && (params[:latitude1].to_f.round(3) == @latest_path.latitude1.to_f.round(3))))
            post2_valid = ((params[:post2] && @latest_path.post2 && (Integer(params[:post2]) == Integer(@latest_path.post2))) ||
                (!params[:post2] && (params[:longitude2].to_f.round(3) == @latest_path.longitude2.to_f.round(3)) && (params[:latitude2].to_f.round(3) == @latest_path.latitude2.to_f.round(3))))

            log_trace(:flyer_path, :setdone, "params|" + params.to_s)
            log_trace(:flyer_path, :setdone, "latest_path|" + @latest_path.as_json.to_s)
            log_trace(:flyer_path, :setdone, "Post1_valid:" + post1_valid.to_s)
            log_trace(:flyer_path, :setdone, "Post2_valid:" + post2_valid.to_s)

            if (post1_valid && post2_valid)
              if @latest_path.update_attributes({:done => true})

                log_event(:flyer_path, :setdone, "success")

                # Update leaderboards
                # Add one more to the number of player posts visited
                start_date = Time.now.beginning_of_week.to_date
                if params[:post2]
                  update_playerposts_lb(@user.id, 1, start_date)
                end

                # Update furthest distance and total distance traveled
                lat1 = 0
                lon1 = 0
                lat2 = 0
                lon2 = 0
                if (params[:post1])
                  post1 = Post.find(params[:post1])
                  lat1 = post1.latitude
                  lon1 = post1.longitude
                else
                  lat1 = params[:latitude1]
                  lon1 = params[:longitude1]
                end
                if (params[:post2])
                  post2 = Post.find(params[:post2])
                  lat2 = post2.latitude
                  lon2 = post2.longitude
                else
                  lat2 = params[:latitude2]
                  lon2 = params[:longitude2]
                end
                distance = Integer(FlyerPathsHelper.haversine_distance(lat1, lon1, lat2, lon2))
                update_totaldistance_lb(@user.id, distance, start_date)
                update_furthest_lb(@user.id, distance, start_date)

                render json: @latest_path.as_json(:only => [:id])
              else
                create_error(:unprocessable_entity, :setdone, params, "Failed to set done on flight path")
              end
            else
              create_error(:forbidden, :setdone, params, "Parameters do not match latest flight path")
            end
          else
            # Path has already been marked as done previously. Don't generate an error, just go ahead and return.
            log_event(:flyer_path, :setdone, "Flight path is already done")
            render json: @latest_path.as_json(:only => [:id])
          end
        #rescue
          #create_error(:unprocessable_entity, :setdone, params, "Data incorrect")
        end
      }
    end
  end
end
