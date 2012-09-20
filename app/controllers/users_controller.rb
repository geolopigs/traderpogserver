require 'securerandom'
require 'logging'
require 'user_leaderboards_helper'

class UsersController < ApplicationController

  include Logging
  include UserLeaderboardsHelper

  def insert_new_friend(userid, new_fbid)
    @current_user = User.find(userid)
    friends_list = @current_user[:fb_friends]
    if !friends_list
      friends_list = ""
    end
    if !friends_list.empty?
      friends_list << "|"
    end
    friends_list << new_fbid
    update_hash = { :fb_friends => friends_list }
    @current_user.update_attributes(update_hash)
  end

  def fb_friends_helper(current_fbid, raw_friends)
    # Takes a list of pipe delimited friend IDs and only returns the ones that
    # are in the user database
    friends_array = raw_friends.split("|")
    trimmed_list = User.where(:fbid => friends_array)
    available_friends = ""
    trimmed_list.each do |friend|
      if !(available_friends.empty?)
        available_friends << "|"
      end
      available_friends << friend[:fbid]
      #insert_new_friend(friend.id, current_fbid)
    end
    available_friends
  end

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
        format.html { # show.html.erb
          @user = User.find(params[:id])
        }
        format.json {
          @user = User.find(params[:id], :select => "id, fbid, member, bucks, email")
          render json: @user.as_json(:except => [:id])
        }
      rescue
        format.html { redirect_to users_url }
        format.json { create_error(:unprocessable_entity, :get, params[:user], "User does not exist") }
      end
    end
  end

  # GET /users/new
  def new
    respond_to do |format|
      format.html { # new.html.erb
        @user = User.new
      }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create

    # Make a copy of the user params
    user_params = (params[:user]).clone

    unless ApplicationHelper.validate_key(request.headers["Validation-Key"])
      # If the validation key is there, then this is a test app talking to us, so
      # accept whatever secret key is passed in. Otherwise, generate a random key.
      user_params.merge!(:secretkey => SecureRandom.uuid)
    end

    # initialize bucks to be 200 and member to be false
    user_params.merge!(:bucks => 200, :member => false)

    # handle fb friends case
    friends = user_params.delete(:fb_friends)
    if friends
      fbid = user_params[:fbid]
      available_friends = fb_friends_helper(fbid, friends)

      user_params.merge!(:fb_friends => available_friends)
    end

    # Create the new user
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save

        # Update bucks for the user for this week
        start_date = Time.now.beginning_of_week.to_date
        update_bucks_lb(@user.id, user_params[:bucks], start_date)

        log_event(:user, :created, user_params)

        @raw_friends = @user.fb_friends
        @friends_array = @raw_friends.split("|")
        @current_user = User.where(:fbid => @friends_array).first
        @friends_list = @current_user.fb_friends

        #test1 = "FB Friends 1:" + @friends_list
        #puts test1

        #if !(@friends_list)
        #  @friends_list = ""
        #end
        #if !(@friends_list.empty?)
        #  @friends_list << "|"
        #end
        @friends_list << @user.fbid

        #test2 = "FB Friends 2:" + @friends_list
        #puts test2

        update_hash = { :fb_friends => @user.fbid }
        @current_user.update_attributes(update_hash)

        @user_2 = User.find(2)
        test3 = "User: " + @user_2.as_json.to_s
        puts test3

        # Be cautious about creating users through the website. The general case is
        # that users are only ever created via the JSON API. The website interface
        # should only be used for debugging purposes.
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user.as_json(:only => [:id, :fbid, :member, :bucks, :email, :secretkey]) }
      else
        format.html { render action: "new" }
        format.json {
          create_error(:unprocessable_entity, :post, user_params, @user.errors)
        }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      format.html {
        @user = User.find(params[:id])
        if @user.update_attributes(params[:user])
          redirect_to @user, notice: 'User was successfully updated.'
        else
          # Some error happened while trying to update the user
          render action: "edit"
        end
      }
      format.json {
        begin
          @user = User.find(params[:id])

          # Make a copy of the user params
          user_params = (params[:user]).clone

          # validate fbid being set
          fbid_valid = true
          fbid = user_params[:fbid]
          if fbid
            @user_by_fbid = User.where("fbid = ?", fbid).first
            if @user_by_fbid && (@user_by_fbid.id != @user.id)
              fbid_valid = false
            end
          end

          if fbid_valid
            # remove fields that are not settable by calling api
            user_params.delete(:secretkey)
            user_params.delete(:member)

            # handle fb friends case
            friends = user_params.delete(:fb_friends)
            if friends
              fbid = user_params[:fbid]
              available_friends = fb_friends_helper(fbid, friends)
              user_params.merge!(:fb_friends => available_friends)
            end

            if @user.update_attributes(user_params)
              log_event(:user, :updated, user_params)

              # update leaderboard for bucks
              bucks = user_params[:bucks]
              if bucks
                start_date = Time.now.beginning_of_week.to_date
                update_bucks_lb(@user.id, bucks, start_date)
              end

              render json: @user.as_json(:only => [:id])
            else
              # Some error happened while trying to update the user
              create_error(:unprocessable_entity, :put, user_params, @user.errors)
            end
          else
            create_error(:unprocessable_entity, :put, user_params, "FacebookID already associated with different user")
          end
        #rescue
          # User does not exist.
        #  create_error(:unprocessable_entity, :put, params[:user], "Encountered error")
        end
      }
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
        format.json {
          if @user
            log_event(:user, :facebook, @user.as_json)
            render json: @user.as_json(:only => [:id, :fbid, :member, :bucks, :email, :secretkey])
          else
            create_error(:not_found, :get, facebookid, "Could not find matching user for facebookid")
          end
        }
      else
        format.json {
          create_error(:not_found, :get, facebookid, "Missing facebookid")
        }
      end
    end
  end
end
