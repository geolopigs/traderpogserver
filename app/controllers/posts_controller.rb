class PostsController < ApplicationController

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
          render json: @posts.as_json(:only => [:id, :img, :latitude, :longitude, :name, :user_id, :item_info_id, :supply, :supplymaxlevel, :supplyratelevel, :beacontime])
        else
          @errormsg = { "errormsg" => "Missing user" }
          render json: @errormsg, status: :unprocessable_entity
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
            render json: @post.as_json(:only => [:id, :img, :supply, :supplymaxlevel, :supplyratelevel, :beacontime])
          else
            render json: @post.errors, status: :unprocessable_entity
          end
        }
      rescue
        @errormsg = { "errormsg" => "Data incorrect" }
        format.html { render 'posts/error', status: :forbidden }
        format.json { render json: @errormsg, status: :forbidden }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    post_params = (params[:post]).clone
    beacontime_error = false
    supply_error = false;

    respond_to do |format|
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
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json {
          if ApplicationHelper.validate_key(request.headers["Validation-Key"])
            render json: @post.as_json(:only => [:id, :supply, :supplymaxlevel, :supplyratelevel])
          else
            render json: @post.as_json(:only => [:id, :supply, :supplymaxlevel, :supplyratelevel, :beacontime])
          end
        }
      else
        if beacontime_error
          # create an error because we're trying to set a live beacon when one already exists
          @errormsg = { "errormsg" => "Beacon already exist on another post" }
          format.html { render 'posts/error', status: :forbidden }
          format.json { render json: @errormsg, status: :forbidden }
        else
          format.html { render action: "edit" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
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

      current_longitude = request.headers["traderpog-longitude"]
      current_latitude = request.headers["traderpog-latitude"]
      if (current_longitude != nil) && (current_latitude != nil)
        @posts = Post.all
        #@post = Post.where("longitude = ?", "#{current_longitude}")
        # compute region
        # lookup based on region
        format.json { render json: @posts.as_json }
      else
        format.json { render :status => 400, :json => { :status => :error, :message => "Error!" }}
      end
    end
  end

  # GET /posts/beacons
  def beacons
    respond_to do |format|

      # Start by getting list of friends based on fbid
      userid = request.headers["user-id"]
      current_user = User.find(userid)
      fbid_array = current_user.fb_friends.split("|")
      friends_list = User.where("fbid in (?)", fbid_array)

      # Find any friend posts that have a beacon set
      userid_array = []
      friend_hash = Hash.new(0)
      friends_list.each do |friend|
        userid_array << friend.id
        friend_hash[friend.id] = friend.fbid
      end
      if ApplicationHelper.validate_key(request.headers["Validation-Key"])
        @posts = Post.select("id, img, latitude, longitude, name, user_id, item_info_id, supply, supplymaxlevel, supplyratelevel").where("user_id in (?) AND beacontime > ?", userid_array, Time.now).limit(20)
      else
        @posts = Post.select("id, img, latitude, longitude, name, user_id, item_info_id, supply, supplymaxlevel, supplyratelevel, beacontime").where("user_id in (?) AND beacontime > ?", userid_array, Time.now).limit(20)
      end
      beacon_list = []
      @posts.as_json.each do |post|
        beacon = post.clone
        beacon['fbid'] = friend_hash[post['id']]
        beacon_list << beacon
      end
      format.json { render json: beacon_list.as_json }
    end
  end

end
