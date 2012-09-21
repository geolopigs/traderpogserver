module UserLeaderboardsHelper

  # types of leaderboards
  BUCKS = 1
  TOTAL_DISTANCE = 2
  FURTHEST_DISTANCE = 3
  PLAYER_POSTS_VISITED = 4

  # types of board styles
  STANDARD = 1
  ADDITIVE = 2
  GREATER_THAN = 3
  LESS_THAN = 4

  def internal_update_lb(userid, current_type, board_style, current_value, startdate)
    success = true
    current_user = User.find(userid)
    board = current_user.user_leaderboards.where("lbtype = ? and weekof = ?", current_type, startdate)
    if board.length == 1
      update_board = true
      case board_style
        when ADDITIVE
          update_params = { :lbvalue => (board.first.lbvalue + current_value) }
        when GREATER_THAN
          if current_value > board.first.lbvalue
            update_params = { :lbvalue => current_value }
          else
            update_board = false
          end
        when LESS_THAN
          if current_value < board.first.lbvalue
            update_params = { :lbvalue => current_value }
          else
            update_board = false
          end
        else
          update_params = { :lbvalue => current_value }
      end

      if update_board
        if board.first.update_attributes(update_params)
          log_event(:userleaderboard, :update, board.first.as_json)
        else
          log_error(:unprocessable_entity, :put, update_params, "Error happened during board update")
        end
      else
        log_event(:userleaderboard, :update, "No change to leaderboard")
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

  def update_bucks_lb(userid, value, startdate)
    if ApplicationHelper.validate_key(request.headers["Validation-Key"])
      internal_update_lb(userid, BUCKS, STANDARD, value, Time.utc(2000,"jan",1).beginning_of_week.to_date)
    else
      internal_update_lb(userid, BUCKS, STANDARD, value, startdate)
    end
  end

  def update_totaldistance_lb(userid, value, startdate)
    if ApplicationHelper.validate_key(request.headers["Validation-Key"])
      internal_update_lb(userid, TOTAL_DISTANCE, ADDITIVE, value, Time.utc(2000,"jan",1).beginning_of_week.to_date)
    else
      internal_update_lb(userid, TOTAL_DISTANCE, ADDITIVE, value, startdate)
    end
  end

  def update_furthest_lb(userid, value, startdate)
    if ApplicationHelper.validate_key(request.headers["Validation-Key"])
      internal_update_lb(userid, FURTHEST_DISTANCE, GREATER_THAN, value, Time.utc(2000,"jan",1).beginning_of_week.to_date)
    else
      internal_update_lb(userid, FURTHEST_DISTANCE, GREATER_THAN, value, startdate)
    end
  end

  def update_playerposts_lb(userid, value, startdate)
    if ApplicationHelper.validate_key(request.headers["Validation-Key"])
      internal_update_lb(userid, PLAYER_POSTS_VISITED, ADDITIVE, value, Time.utc(2000,"jan",1).beginning_of_week.to_date)
    else
      internal_update_lb(userid, PLAYER_POSTS_VISITED, ADDITIVE, value, startdate)
    end
  end
end
