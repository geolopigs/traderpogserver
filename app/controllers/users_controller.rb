class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    respond_to do |format|
      format.html { # index.html.erb
        @users = User.all
      }
      #format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    begin
      @user = User.find(params[:id])
    rescue
      @user = nil
    end
    if @user.nil?
      # Handle the case where the user is not found
      respond_to do |format|
        format.html { redirect_to users_url }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
      end
    end
  end

  # GET /users/new
  def new
    respond_to do |format|
      format.html { # new.html.erb
        @user = User.new
      }
      # JSON should use the PUTS API to create a new user
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    # NOTE: This is here purely for debugging purposes. Users should not be created through
    # the website, but rather through the JSON PUTS API.
    respond_to do |format|
      format.html {
        @user = User.new(params[:user])
        if @user.save
          redirect_to @user, notice: 'User was successfully created.'
        else
          render action: "new"
        end
      }
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    success = true
    @user = nil

    begin
      # first, check if the user has already been created.
      @user = User.find(params[:id])
    rescue
      @user = nil
    end

    # user doesn't exist yet. create a new user entry and set their id
    # to match the one in ProfilePog
    if @user.nil?
      # new user
      @user = User.new
      @user.id = params[:id]
      success = @user.save
    end

    # if everything looks good so far, set the attributes for the user
    if success
      success = @user.update_attributes(params[:user])
    end

    # respond to the call appropriately
    respond_to do |format|
      if success
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render json: @user.as_json(:only => [:id]) }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    respond_to do |format|
      format.html {
        @user = User.find(params[:id])
        @user.destroy
        redirect_to users_url
      }
    end
  end

  # GET /users/1/beacons
  def beacons
    @beacons = Beacon.where("user_id = ? AND used = ? AND expiration > ?", params[:id], false, Time.now)
    respond_to do |format|
      format.json {
        render json: @beacons.as_json(:only => [:user_id, :post_id, :expiration])
      }
    end
  end
end
