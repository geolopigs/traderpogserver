module FlyerPathsHelper

  # PI = 3.1415926535
  RAD_PER_DEG = 0.017453293  #  PI/180

  RKM = 6371              # radius in kilometers...some algorithms use 6367
  RMETERS = RKM * 1000    # radius in meters

  def FlyerPathsHelper.haversine_distance( lat1, lon1, lat2, lon2 )

    dlon = lon2 - lon1
    dlat = lat2 - lat1

    dlon_rad = dlon * RAD_PER_DEG
    dlat_rad = dlat * RAD_PER_DEG

    lat1_rad = lat1 * RAD_PER_DEG
    lon1_rad = lon1 * RAD_PER_DEG

    lat2_rad = lat2 * RAD_PER_DEG
    lon2_rad = lon2 * RAD_PER_DEG

    # puts "dlon: #{dlon}, dlon_rad: #{dlon_rad}, dlat: #{dlat}, dlat_rad: #{dlat_rad}"

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math.asin( Math.sqrt(a))

    dKm = RKM * c     # delta in kilometers
    [dKm, 1].max      # always make it at least 1km
  end
end
