class FlyerPathsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @userflyer = @user.user_flyers.find(params[:user_flyer_id])
    @flyer_paths = @userflyer.flyer_paths;

    respond_to do |format|
      format.html { head :no_content }
      format.json { render json: @flyer_paths.as_json(:only => [:id, :post1, :post2, :longitude1, :latitude1, :longitude2, :latitude2, :storms, :stormed]) }
    end
  end

  def show
    @user = User.find(params[:user_id])
    @userflyer = @user.user_flyers.find(params[:user_flyer_id])
    @flyer_path = @userflyer.flyer_paths(params[:id])

    respond_to do |format|
      format.html { head :no_content }
      format.json { render json: @flyer_path.as_json(:only => [:id, :post1, :post2, :longitude1, :latitude1, :longitude2, :latitude2, :storms, :stormed]) }
    end
  end

  def create
    @user = User.find(params[:user_id])
    @userflyer = @user.user_flyers.find(params[:user_flyer_id])

    respond_to do |format|
      flyer_path = @userflyer.flyer_paths.create(params[:flyer_path])
      if flyer_path
        format.html { redirect_to @user, notice: 'Flyer path was successfully created.' }
        format.json { render json: flyer_path.as_json(:only => [:id]) }
      else
        format.html { render action: "new" }
        format.json { render json: flyer_path.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:user_id])
    @flyer_path = FlyerPath.find(params[:id])

    respond_to do |format|
      if @flyer_path.update_attributes(params[:flyer_path])
        format.html { redirect_to @user, notice: 'Flyer path was successfully updated.' }
        format.json { head :no_content }
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
