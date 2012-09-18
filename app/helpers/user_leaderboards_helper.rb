module UserLeaderboardsHelper

  # types of leaderboards
  COINS = 1
  TOTAL_DISTANCE = 2
  FURTHEST_DISTANCE = 3
  PLAYER_POSTS_VISITED = 4
  BEACONS_VISITED = 5

  def internal_update_lb(userid, current_type, current_value, startdate)
    success = true
    current_user = User.find(userid)
    board = current_user.user_leaderboards.where("lbtype = ? and weekof = ?", current_type, startdate)
    if board.length == 1
      # Existing value, go ahead and update the value
      update_params = { :value => current_value }
      if board.first.update_attributes(update_params)
        log_event(:userleaderboard, :update, board.first.as_json)
      end
    else
      if board.length == 0
        # new param, need to create it
        new_params = { :user_id => userid, :lbtype => current_type, :lbvalue => current_value, :weekof => startdate }
        new_board = UserLeaderboard.create(new_params)
        if new_board
          log_event(:userleaderboard, :create, new_board.as_json)
        end
      else
        log_error(:unprocessable_entity, :put, board.as_json, "More than one entry for given type of leaderboard in a week")
      end
    end
  end

  def update_coins_lb(userid, value, startdate)
    if ApplicationHelper.validate_key(request.headers["Validation-Key"])
      internal_update_lb(userid, COINS, value, Time.utc(2000,"jan",1).beginning_of_week.to_date)
    else
      internal_update_lb(userid, COINS, value, startdate)
    end
  end
end
