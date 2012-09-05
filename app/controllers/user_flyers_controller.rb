class UserFlyersController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @userflyers = @user.user_flyers

    respond_to do |format|
      format.html { head :no_content }
      format.json {
        @complete_userflyers = @userflyers.collect { |userflyer|
          if ApplicationHelper.validate_key(request.headers["Validation-Key"])
            path = UserFlyersHelper.getflyerpaths(userflyer, 1, true)
          else
            path = UserFlyersHelper.getflyerpaths(userflyer, 1, false)
          end
          userflyer.as_json(:only => [:id, :flyer_info_id, :item_info_id, :num_items, :cost_basis, :meterstraveled]).merge(path)
        }
        render json: @complete_userflyers
      }
    end
  end

  def show
    @user = User.find(params[:user_id])
    @userflyer = @user.user_flyers.find(params[:id])

    respond_to do |format|
      format.html { head :no_content }
      format.json {
        if ApplicationHelper.validate_key(request.headers["Validation-Key"])
          path = UserFlyersHelper.getflyerpaths(@userflyer, 1, true)
        else
          path = UserFlyersHelper.getflyerpaths(@userflyer, 1, false)
        end
        render json: @userflyer.as_json(:only => [:id, :flyer_info_id, :item_info_id, :num_items, :cost_basis, :meterstraveled]).merge(path)
      }
    end
  end

  def create
    @user = User.find(params[:user_id])

    # add default parameter values
    user_flyer_params = (params[:user_flyer]).clone
    user_flyer_params.merge!(:item_info_id => nil, :num_items => 0, :cost_basis => 0.0, :meterstraveled => 0.0)

    respond_to do |format|
      format.html {
        user_flyer = @user.user_flyers.create(params[:user_flyer_params])
        if user_flyer
          redirect_to @user, notice: 'Flyer was successfully created.'
        else
          render action: "new"
        end
      }
      format.json {
        postid = request.headers["Init-Post-Id"]
        if postid
          user_flyer = @user.user_flyers.create(user_flyer_params)
          if user_flyer
            # create an initial position for the Flyer located at some Post
            flyer_path = { "post1" => postid, "post2" => postid, "storms" => 0, "stormed" => 0, "done" => true, "item_info_id" => nil, "num_items" => 0, "price" => 0 }
            flyer_path_record = user_flyer.flyer_paths.create(flyer_path)

            render json: user_flyer.as_json(:only => [:id])
          else
            render json: user_flyer.errors, status: :unprocessable_entity
          end
        else
          @errormsg = { "errormsg" => "Missing Post ID" }
          render json: @errormsg, status: :unprocessable_entity
        end
      }
    end
  end

  def update
    @user = User.find(params[:user_id])
    @userflyer = @user.user_flyers.find(params[:id])

    respond_to do |format|
      format.html {
        if @userflyer.update_attributes(params[:user_flyer])
          redirect_to @user, notice: 'User flyer was successfully updated.'
        else
          render action: "edit"
        end
        }
      format.json {
        @flyerpath = @userflyer.flyer_paths.order("created_at DESC").first
        user_flyer_params = params[:user_flyer].clone

        user_flyer_msg = "User flyer params:" + user_flyer_params.to_s
        puts user_flyer_msg

        flyer_path_params = params[:flyer_path].clone

        flyer_path_msg = "Flyer path params:" + flyer_path_params.to_s
        puts flyer_path_msg

        success = true
        if user_flyer_params.length > 0
          if !(@userflyer.update_attributes(user_flyer_params))
            success = false
          end
        end
        if success && flyer_path_params && flyer_path_params.length > 0
          if !(@flyerpath.update_attributes(flyer_path_params))
            success = false
          end
        end

        if success
          render json: @userflyer.as_json(:only => [:id])
        else
          render json: @userflyer.errors, status: :unprocessable_entity
        end
        }
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @userflyer = @user.user_flyers.find(params[:id])
    @userflyer.destroy

    respond_to do |format|
      format.html { redirect_to @user }
      format.json { head :no_content }
    end
  end
end
