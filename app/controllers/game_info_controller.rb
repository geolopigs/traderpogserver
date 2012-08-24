class GameInfoController < ApplicationController
  def show
    respond_to do |format|
      format.json {
        gameinfo = Hash.new
        gameinfo[:lastupdated] = Time.now
        begin
          # Update existing game info time
          @game_info = GameInfo.find(1)
        rescue
          # Create new game info time
          @game_info = GameInfo.new(gameinfo)
        end
        render json: @game_info.as_json(:only => :lastupdated)
      }
    end
  end
end
