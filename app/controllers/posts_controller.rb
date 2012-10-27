require 'logging'

class PostsController < ApplicationController

  include Logging

  # GET /posts
  # GET /posts.json
  def index
    respond_to do |format|
      format.html { # index.html.erb
        @posts = Post.all
      }
      format.json {
      @language = ApplicationHelper.preferred_language(request.headers["Accept-Language"])
       user_id = request.headers["user-id"]
       if user_id
          @posts = Post.where("user_id = ?", user_id)
          log_event(:post, :retrieve_post, user_id)
          render json: @posts.as_json(:only => [:id, :img, :latitude, :longitude, :name, :user_id, :item_info_id, :supply, :supplymaxlevel, :supplyratelevel, :beacontime])
        else
          create_error(:unprocessable_entity, :get, params[:post], "User not found")
        end
      }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    # Get the Accept-Language first. If it doesn't exist, default to en
    @language = ApplicationHelper.preferred_language(request.headers["Accept-Language"])

    respond_to do |format|
      format.html { # show.html.erb
        @post = Post.find(params[:id])
      }
      format.json {
        @post = Post.find(params[:id], :select => "id, img, latitude, longitude, name, user_id, item_info_id, supply, supplymaxlevel, supplyratelevel, beacontime")
        log_event(:post, :retrieve_single_post, params[:id])
        render json: @post.as_json
      }
    end
  end

  # GET /posts/new
  def new
    # no JSON API for this. We create new posts using posts.json
    respond_to do |format|
      format.html { # new.html.erb
        @post = Post.new
      }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    respond_to do |format|
      # Check that the user exists first
      begin
        @user = User.find((params[:post])[:user_id])
        @item_info = ItemInfo.find((params[:post])[:item_info_id])

        format.html {
          @post = Post.new(params[:post])
          if @post.save
            redirect_to @post, notice: 'Post was successfully created.'
          else
            render action: "new"
          end
        }
        format.json {
          # Make a copy of the post params
          post_params = (params[:post]).clone

          # impose max and min on the latitude, longitude values
          latitude = [[post_params[:latitude].to_f, 90].min, -90].max
          longitude = [[post_params[:longitude].to_f, 180].min, -180].max
          post_params.merge!(:latitude => latitude, :longitude => longitude)

          # calculate the region value
          region = PostsHelper.coordtoregion(post_params[:latitude], post_params[:longitude], 0.02)

          # initialize standard values for new posts
          post_params.merge!(:name => "", :img => "default", :region => region, :supply => @item_info.supplymax, :supplymaxlevel => 1, :supplyratelevel => 1, :disabled => false)

          @post = Post.new(post_params)
          if @post.save
            log_event(:post, :create, @post.as_json)
            render json: @post.as_json(:only => [:id, :img, :supply, :supplymaxlevel, :supplyratelevel, :beacontime])
          else
            create_error(:unprocessable_entity, :post, params[:post], @post.errors)
          end
        }
      rescue
        @errormsg = { "errormsg" => "Data incorrect" }
        format.html { render 'posts/error', status: :forbidden }
        format.json {
          create_error(:unprocessable_entity, :post, params[:post], "Exception occurred")
        }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    post_params = (params[:post]).clone
    beacontime_error = false
    supply_error = false
    num_of_items_sold = 0

    respond_to do |format|
      format.html {
        if @post.update_attributes(post_params)
          redirect_to @post, notice: 'Post was successfully updated.'
        else
          format.html { render action: "edit" }
        end
      }
      format.json {

        # Check if user is trying to set beacon...
        if post_params[:beacontime] != nil
          userid = @post.user_id
          live_beacons = Post.where("user_id = ? and beacontime IS NOT NULL and beacontime >= ?", userid, Time.now)
          if (live_beacons.length == 0)
            # No live beacon currently exists, go ahead and create the beacontime
            post_params.merge!(:beacontime => (Time.now + (24 * 60 * 60 * 7)))
          else
            beacontime_error = true
          end
        end

        # Check if user is trying to set supply
        if post_params[:supply] != nil
          current_supply = @post.supply
          change_value = Integer(post_params[:supply])
          if (change_value <= 0)
            new_supply = current_supply + change_value
            post_params.merge!(:supply => [new_supply, 0].max)
            num_of_items_sold = [current_supply, change_value.abs].min
            # updates that reduce the supply value of a post must stand alone
            if (post_params.size > 1)
              supply_error = true
            end
          else
            @item_info = @post.item_info
            new_supply = [(@post.supplymaxlevel - 1) * @item_info.multiplier, 1].max * @item_info.supplymax
            post_params.merge!(:supply => new_supply)
          end
        end

        if !supply_error && !beacontime_error && @post.update_attributes(post_params)
          log_event(:post, :update, @post.as_json)

          # record sale
          if num_of_items_sold > 0
            fbid = request.headers["fbid"]
            @item = ItemInfo.find(@post.item_info_id)
            amount = 0.05 * num_of_items_sold * @item.price
            @sale = Sale.new({ :post_id => @post.id, :user_id => @post.user_id, :amount => Integer(amount), :fbid => fbid })
            @sale.save
          end

          if ApplicationHelper.validate_key(request.headers["Validation-Key"])
            render json: @post.as_json(:only => [:id, :supply, :supplymaxlevel, :supplyratelevel])
          else
            render json: @post.as_json(:only => [:id, :supply, :supplymaxlevel, :supplyratelevel, :beacontime])
          end
        else
          if beacontime_error
            # create an error because we're trying to set a live beacon when one already exists
            create_error(:forbidden, :put, post_params, "Beacon already exist on another post")
          else
            if supply_error
              create_error(:forbidden, :put, post_params, "Supply updates must stand alone")
            else
              create_error(:unprocessable_entity, :put, post_params, @post.errors)
            end
          end
        end
      }
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    # no JSON API for this. We can only delete posts through the webpage.
    respond_to do |format|
      format.html {
        @post = Post.find(params[:id])
        @post.destroy
        redirect_to posts_url
      }
    end
  end

  # GET /posts/scan
  def scan
    respond_to do |format|
      userid = request.headers["user-id"]
      current_longitude = request.headers["traderpog-longitude"]
      current_latitude = request.headers["traderpog-latitude"]
      fraction = 0.02
      input_list = { :userid => userid, :current_latitude => current_latitude, :current_longitude => current_longitude }
      if (current_longitude != nil) && (current_latitude != nil) && (userid != nil)
        current_longitude = current_longitude.to_f
        current_latitude = current_latitude.to_f

        # get the region for the current point
        region = PostsHelper.coordtoregion(current_latitude, current_longitude, fraction)
        # get the surrounding regions
        regions_array = PostsHelper.getsurroundingregions(region, fraction)
        # add the current region to the list of regions
        regions_array << region

        @posts = Post.select("id, img, latitude, longitude, name, user_id, item_info_id, supply, supplymaxlevel, supplyratelevel, disabled").where("region in (?) AND user_id <> ?", regions_array, userid).limit(100)
        input_list.merge!(:posts => @posts.as_json)
        log_event(:post, :scan, input_list)

        format.json { render json: @posts.as_json }
      else
        format.json {
          create_error(:unprocessable_entity, :scan, input_list, "Missing required parameter")
        }
      end
    end
  end

  # GET /posts/beacons
  def beacons
    respond_to do |format|

      # Start by getting list of friends based on fbid
      userid = request.headers["user-id"]
      current_user = User.find(userid)
      beacon_list = []
      friend_hash = Hash.new(0)
      fbid_array = current_user.fb_friends
      if fbid_array
        fbid_array = fbid_array.split("|")
        friends_list = User.where("fbid in (?)", fbid_array)

        # Find any friend posts that have a beacon set
        userid_array = []
        friends_list.each do |friend|
          userid_array << friend.id
          friend_hash[friend.id] = friend.fbid
        end
        if ApplicationHelper.validate_key(request.headers["Validation-Key"])
          @posts = Post.select("id, img, latitude, longitude, name, user_id, item_info_id, supply, supplymaxlevel, supplyratelevel").where("user_id in (?) AND beacontime > ?", userid_array, Time.now).limit(20)
        else
          @posts = Post.select("id, img, latitude, longitude, name, user_id, item_info_id, supply, supplymaxlevel, supplyratelevel, beacontime").where("user_id in (?) AND beacontime > ?", userid_array, Time.now).limit(20)
        end
        @posts.as_json.each do |post|
          beacon = post.clone
          beacon['fbid'] = friend_hash[post['user_id']]
          beacon_list << beacon
        end
      end
      beacon_info = { :userid => userid, :beacons => beacon_list }
      log_event(:post, :beacons, beacon_list)
      format.json { render json: beacon_list.as_json }
    end
  end

end
