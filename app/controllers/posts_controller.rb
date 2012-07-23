class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index

    # no JSON API for this. We can only access all posts through the webpage.
    respond_to do |format|
      format.html { # index.html.erb
        @posts = Post.all
      }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    # Get the Accept-Language first. If it doesn't exist, default to en
    @language = ApplicationHelper.preferred_language(request.headers["Accept-Language"])
    @post = Post.find(params[:id], :select => "id, img, latitude, longitude, name, region, user_id, item_info_id, supplymaxlevel, supplyratelevel")

    respond_to do |format|
      format.html   # show.html.erb
      format.json {
        @item_info = @post.item_info(:select => "id, price, supplymax, supplyrate, multiplier")
        @item_loc = ItemInfosHelper.getitemloc(@item_info, @language)
        render json: @post.as_json.merge(@item_info.as_json.merge(@item_loc.first.as_json))
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

        # Make a copy of the post params
        post_params = (params[:post]).clone

        # initialize bucks to be 0 and member to be false
        post_params.merge!(:name => "", :img => "default", :region => 0, :supplymaxlevel => 1, :supplyratelevel => 1)

        @post = Post.new(post_params)
        if @post.save
          format.html { redirect_to @post, notice: 'Post was successfully created.' }
          format.json { render json: @post.as_json(:only => [:id, :img, :supplymaxlevel, :supplyratelevel]) }
        else
          format.html { render action: "new" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
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

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
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

end
