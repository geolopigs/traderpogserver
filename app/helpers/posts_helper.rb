module PostsHelper
  ##
  # Get the region that the post is located in
  ##
  def PostsHelper.coordtoregion(latitude, longitude, fraction)
    lat_index = PostsHelper.get_index(latitude, fraction, -90, 90)
    lon_index = PostsHelper.get_index(longitude, fraction, -180, 180)
    (lat_index * 360 * (1.0 / fraction).to_int) + lon_index
  end

  def PostsHelper.get_index(point, fraction, min_val, max_val)
    low_index = 0
    hi_index = ((max_val - min_val) * (1.0 / fraction)).to_int - 1
    mid_index = (low_index + hi_index) / 2
    current_index = -1
    rounded_point = point.round(8)
    done = false

    if (rounded_point == min_val)
      current_index = low_index
    else
      if (rounded_point == max_val)
        current_index = hi_index
      else
        while !done
          left = min_val + (fraction * mid_index)
          left = left.round(8)
          right = left + fraction
          right = right.round(8)

          if rounded_point >= left && rounded_point < right
            current_index = mid_index
            done = true
          else
            if rounded_point < left
              hi_index = mid_index - 1
            else
              low_index = mid_index + 1
            end
            mid_index = (low_index + hi_index) / 2
            mid_index = mid_index.round(0)
          end
        end
      end
    end

    # return the current index
    current_index
  end
end
