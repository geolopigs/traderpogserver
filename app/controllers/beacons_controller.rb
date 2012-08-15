class BeaconsController < ApplicationController

  def index
    respond_to do |format|
      format.json {
        friends_list = User.find(user_id).select("fbid")
        friends_array = raw_friends.split("|")
        @beacons = Beacon.where("fbid in ? AND expiration > ?", friends_array, Time.now).limit(20)
        render json: @beacons.as_json("user_id, fbid, post_id, expiration")
      }
      format.html { # index.html.erb
        @beacons = Beacon.all
      }
    end
  end

  def show
    @beacon = Beacon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @beacon }
    end
  end

  # GET /beacons/new
  # GET /beacons/new.json
  def new
    @beacon = Beacon.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @beacon }
    end
  end

  # GET /beacons/1/edit
  def edit
    @beacon = Beacon.find(params[:id])
  end

  def create
    respond_to do |format|
      begin
        @user = User.find(params[:user_id])

        # Validate beacon is legitimate. Make sure post is owned by user and there are no active beacons
        @post = Post.find(params[:post_id])
        @live_beacons = Beacon.where("user_id = ? AND expiration > ?", params[:user_id], Time.now)
        if (@post.user_id == Integer(params[:user_id]) && @live_beacons.length == 0)
          # Make a copy of the beacon params
          beacon_params = (params[:beacon]).clone
          beacon_params.merge!(:fbid => @user.fbid)
          beacon_params.merge!(:expiration => (Time.now + (24 * 60 * 60 * 7)))
          beacon = @user.beacons.create(beacon_params)
          if beacon.valid?
            format.html { redirect_to @user, notice: 'Beacon was successfully created.' }
            format.json {
              if ApplicationHelper.validate_key(request.headers["Validation-Key"])
                # this is a test response, don't send the created_at field
                render json: beacon.as_json(:only => [:id])
              else
                render json: beacon.as_json(:only => [:id, :expiration])
              end
            }
          else
            format.html { render action: "new" }
            format.json { render json: beacon.errors, status: :unprocessable_entity }
          end
        else
          @errormsg = { "errormsg" => "Data incorrect" }
          format.html { render 'posts/error', status: :forbidden }
          format.json { render json: @errormsg, status: :forbidden }
        end
      rescue
        @errormsg = { "errormsg" => "Data incorrect" }
        format.html { render 'posts/error', status: :forbidden }
        format.json { render json: @errormsg, status: :forbidden }
      end
    end
  end

  def update
    begin
      @user = User.find(params[:user_id])
      @beacon = Beacon.find(params[:id])

      respond_to do |format|
        if @beacon.update_attributes(params[:beacon])
          format.html { redirect_to @user, notice: 'Beacon was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @beacon.errors, status: :unprocessable_entity }
        end
      end
    rescue
      @errormsg = { "errormsg" => "Data incorrect" }
      format.html { render 'posts/error', status: :forbidden }
      format.json { render json: @errormsg, status: :forbidden }
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @beacon = @user.beacons.find(params[:id])
    @beacon.destroy

    respond_to do |format|
      format.html { redirect_to @user }
      format.json { head :no_content }
    end
  end
end
