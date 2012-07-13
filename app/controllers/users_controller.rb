require 'securerandom'

class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    respond_to do |format|
      format.html { # index.html.erb
        @users = User.all
      }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      begin
        @user = User.find(params[:id])
        format.html # show.html.erb
        format.json { render json: @user.as_json(:only => [:id, :fbid, :member, :bucks, :email]) }
      rescue
        format.html { redirect_to users_url }
        format.json { head :no_content }
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

    puts params

    # Make a copy of the user params
    user_params = (params[:user]).clone

    unless ApplicationHelper.validate_key(request.headers["Validation-Key"])
      # If the validation key is there, then this is a test app talking to us, so
      # accept whatever secret key is passed in. Otherwise, generate a random key.
      user_params.merge!(:secretkey => SecureRandom.uuid)
    end

    # initialize bucks to be 0 and member to be false
    user_params.merge!(:bucks => 0, :member => false)

    # Create the new user
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        # Be cautious about creating users through the website. The general case is
        # that users are only ever created via the JSON API. The website interface
        # should only be used for debugging purposes.
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user.as_json(:only => [:id, :fbid, :member, :bucks, :email, :secretkey]) }
      else
        format.html { render action: "new" }
        format.json {
          puts @user.errors
          render json: @user.errors, status: :unprocessable_entity
        }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      begin
        @user = User.find(params[:id])
        if @user.update_attributes(params[:user])
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render json: @user.as_json(:only => [:id, :fbid, :member, :bucks, :email]) }
        else
          # Some error happened while trying to update the user
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      rescue
        # User does not exist.
        format.html { render action: "edit" }
        format.json { render json: "User error", status: :unprocessable_entity }
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

  # GET /users/facebook
  def facebook
    respond_to do |format|

      facebookid = request.headers["Facebook-Id"]
      if facebookid
        @user = User.where("fbid = ?", "#{facebookid}").first
        format.json { render json: @user.as_json(:only => [:id, :fbid, :member, :bucks, :email, :secretkey])}
      else
        format.json { render :status => 400, :json => { :status => :error, :message => "Not found!" }}
      end
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
