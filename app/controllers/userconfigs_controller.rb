class UserconfigsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @userconfigs = @user.userconfigs

    respond_to do |format|
      format.html { head :no_content }
      format.json { render json: @userconfigs.as_json(:only => [:key, :value]) }
    end
  end

  def show
    @user = User.find(params[:user_id])
    @userconfig = @user.userconfigs.find(params[:id])

    respond_to do |format|
      format.html { head :no_content }
      format.json { render json: @userconfig.as_json(:only => [:key, :value]) }
    end
  end

  def create
    @user = User.find(params[:user_id])

    respond_to do |format|
      if @user.userconfigs.create(params[:userconfig])
        format.html { redirect_to @user, notice: 'Config was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end
end
