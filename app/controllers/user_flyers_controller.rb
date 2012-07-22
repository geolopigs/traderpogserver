class UserFlyersController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @userflyers = @user.user_flyers

    respond_to do |format|
      format.html { head :no_content }
      format.json { render json: @userflyers.as_json(:only => [:id, :flyer_info_id]) }
    end
  end

  def show
    @user = User.find(params[:user_id])
    @userconfig = @user.user_flyers.find(params[:id])

    respond_to do |format|
      format.html { head :no_content }
      format.json { render json: @userconfig.as_json(:only => [:id, :flyer_info_id]) }
    end
  end

  def create
    @user = User.find(params[:user_id])

    respond_to do |format|
      user_flyer = @user.user_flyers.create(params[:user_flyer])
      if user_flyer
        format.html { redirect_to @user, notice: 'Flyer was successfully created.' }
        format.json { render json: user_flyer.as_json(:only => [:id]) }
      else
        format.html { render action: "new" }
        format.json { render json: user_flyer.errors, status: :unprocessable_entity }
      end
    end
  end
end
