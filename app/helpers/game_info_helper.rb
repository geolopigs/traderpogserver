module GameInfoHelper
  def GameInfoHelper.updateTime
    gameinfo = Hash.new
    gameinfo[:lastupdated] = Time.now
    begin
      # Update existing game info time
      @game_info = GameInfo.find(1)
      @game_info.update_attributes(gameinfo)
    rescue
      # Create new game info time
      @game_info = GameInfo.new(gameinfo)
      @game_info.save
    end
  end
end
