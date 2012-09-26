require 'logging'

class UserLeaderboardsController < ApplicationController

  include Logging

  # @param [Object] userid
  def get_leaderboard_values_for_user(userid, fbid, member)
    if ApplicationHelper.validate_key(request.headers["Validation-Key"])
      start_datetime = Time.utc(2000,"jan",1).beginning_of_week
    else
      current_time = Time.now
      start_datetime = current_time.beginning_of_week
    end
    boards = UserLeaderboard.where("user_id = ? and weekof = ?", userid, start_datetime.to_date).select("lbtype, lbvalue, weekof").as_json
    boards.each do |board|
      board.merge!({ :fbid => fbid, :member => member })
    end
    boards
  end

  # GET /user_leaderboards
  # GET /user_leaderboards.json
  def index
    respond_to do |format|
      format.json {
        user_leaderboard = []
        userid = params[:user_id]
        if userid
          # First, get the list of leaderboard values for current user
          current_user = User.find(userid)
          user_leaderboard << get_leaderboard_values_for_user(userid, current_user.fbid, current_user.member)

          # Then, get leaderboard values for user's friends
          fbid_array = current_user.fb_friends
          if fbid_array.length > 0
            fbid_array = fbid_array.split("|")
            friends_list = User.where("fbid in (?)", fbid_array)

            friends_list.each do |friend|
              user_leaderboard << get_leaderboard_values_for_user(friend.id, friend.fbid, friend.member)
            end
          end

          log_event(:user_leaderboard, :get, user_leaderboard)
          render json: user_leaderboard.as_json
        else
          create_error(:unprocessable_entity, :get, "", "Missing user")
        end
      }
    end
  end
end
