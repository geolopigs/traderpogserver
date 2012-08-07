module UserFlyersHelper

  # @param [Object] userflyer
  # @param [Object] count
  def UserFlyersHelper.getflyerpaths(userflyer, count, test)
    if (test)
      # this is a test response, don't send the created_at field
      {"flyer_paths" => userflyer.flyer_paths.select("id, post1, post2, longitude1, longitude2, latitude1, latitude2, storms, stormed").limit(count).order("created_at DESC")}
    else
      {"flyer_paths" => userflyer.flyer_paths.select("id, created_at, post1, post2, longitude1, longitude2, latitude1, latitude2, storms, stormed").limit(count).order("created_at DESC")}
    end
  end
end
