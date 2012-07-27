module UserFlyersHelper

  # @param [Object] userflyer
  # @param [Object] count
  def UserFlyersHelper.getflyerpaths(userflyer, count)
    {"flyer_paths" => userflyer.flyer_paths.select("created_at, post1, post2, longitude1, longitude2, latitude1, latitude2, storms, stormed").limit(count).order("created_at DESC")}
  end
end
