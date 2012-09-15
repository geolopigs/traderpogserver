require 'logging'

class FlyerPathsController < ApplicationController

  include Logging

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
end
