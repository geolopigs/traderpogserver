class FlyerPathsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @userflyer = @user.user_flyers.find(params[:user_flyer_id])
    pathscount = request.headers["Flyer-Paths-Count"]
    if pathscount == 0
      pathscount = 1
    end

    if ApplicationHelper.validate_key(request.headers["Validation-Key"])
      # this is a test response, don't send the created_at field
      path = @userflyer.flyer_paths.select("id, post1, post2, longitude1, longitude2, latitude1, latitude2, storms, stormed, done")
    else
      path = @userflyer.flyer_paths.select("id, created_at, post1, post2, longitude1, longitude2, latitude1, latitude2, storms, stormed, done")
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
      path = @userflyer.flyer_paths(params[:id]).select("id, post1, post2, longitude1, longitude2, latitude1, latitude2, storms, stormed, done")
    else
      path = @userflyer.flyer_paths(params[:id]).select("id, created_at, post1, post2, longitude1, longitude2, latitude1, latitude2, storms, stormed, done")
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
            if ApplicationHelper.validate_key(request.headers["Validation-Key"])
              # this is a test response, don't send the created_at field
              render json: flyer_path.as_json(:only => [:id])
            else
              render json: flyer_path.as_json(:only => [:id, :created_at])
            end
          }
        else
          format.html { render action: "new" }
          format.json { render json: flyer_path.errors, status: :unprocessable_entity }
        end
      else
        @errormsg = { "errormsg" => "Post not found" }
        format.html { render 'posts/error', status: :not_found }
        format.json { render json: @errormsg, status: :not_found }
      end
    end
  end

  def update
    @user = User.find(params[:user_id])
    @flyer_path = FlyerPath.find(params[:id])

    respond_to do |format|
      if @flyer_path.update_attributes(params[:flyer_path])
        format.html { redirect_to @user, notice: 'Flyer path was successfully updated.' }
        format.json { render json: @flyer_path.as_json(:only => [:id]) }
      else
        format.html { render action: "edit" }
        format.json { render json: @flyer_path.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @flyer_path = FlyerPath.find(params[:id])
    @flyer_path.destroy

    respond_to do |format|
      format.html { redirect_to @user }
      format.json { head :no_content }
    end
  end
end
