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
    rounded_point = point
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

  def PostsHelper.getsurroundingregions(region, fraction)
    regions_array = []
    num_cols = ((1.0 / fraction) * 360).round(0)
    num_rows = ((1.0 / fraction) * 180).round(0)
    first_value_in_last_row = num_cols * (num_rows - 1)
    last_value_in_last_row = (num_cols * num_rows) - 1

    # general case
    if !PostsHelper.IsLeftEdge(region, fraction) && !PostsHelper.IsRightEdge(region, fraction) && !PostsHelper.IsTopRow(region, fraction) && !PostsHelper.IsBottomRow(region, fraction)
      regions_array << (region - num_cols - 1)
      regions_array << (region - num_cols)
      regions_array << (region - num_cols + 1)
      regions_array << (region - 1)
      regions_array << (region + 1)
      regions_array << (region + num_cols - 1)
      regions_array << (region + num_cols)
      regions_array << (region + num_cols + 1)
    end

    # top row except for left and right edges (which are corners)
    if (regions_array.length == 0) && !PostsHelper.IsLeftEdge(region, fraction) && !PostsHelper.IsRightEdge(region, fraction) && PostsHelper.IsTopRow(region, fraction)
      regions_array << (region + first_value_in_last_row - 1)
      regions_array << (region + first_value_in_last_row)
      regions_array << (region + first_value_in_last_row + 1)
      regions_array << (region - 1)
      regions_array << (region + 1)
      regions_array << (region + num_cols - 1)
      regions_array << (region + num_cols)
      regions_array << (region + num_cols + 1)
    end

    # bottom row except for edges (which are corners)
    if (regions_array.length == 0) && !PostsHelper.IsLeftEdge(region, fraction) && !PostsHelper.IsRightEdge(region, fraction) && PostsHelper.IsBottomRow(region, fraction)
      regions_array << (region - num_cols - 1)
      regions_array << (region - num_cols)
      regions_array << (region - num_cols + 1)
      regions_array << (region - 1)
      regions_array << (region + 1)
      regions_array << (region - first_value_in_last_row - 1)
      regions_array << (region - first_value_in_last_row)
      regions_array << (region - first_value_in_last_row + 1)
    end

    # left edge except for corners. tricky ones are left, upper left, and lower left
    if (regions_array.length == 0) && PostsHelper.IsLeftEdge(region, fraction) && !PostsHelper.IsTopRow(region, fraction) && !PostsHelper.IsBottomRow(region, fraction)
      regions_array << (region - 1)
      regions_array << (region - num_cols)
      regions_array << (region - num_cols + 1)
      regions_array << (region - 1 + num_cols)
      regions_array << (region + 1)
      regions_array << (region - 1 + num_cols + num_cols)
      regions_array << (region + num_cols)
      regions_array << (region + num_cols + 1)
    end

    # right edge except for corners. tricky ones are right, upper right, lower right
    if (regions_array.length == 0) && PostsHelper.IsRightEdge(region, fraction) && !PostsHelper.IsTopRow(region, fraction) && !PostsHelper.IsBottomRow(region, fraction)
      regions_array << (region - num_cols - 1)
      regions_array << (region - num_cols)
      regions_array << (region - num_cols - num_cols + 1)
      regions_array << (region - 1)
      regions_array << (region - num_cols + 1)
      regions_array << (region + num_cols - 1)
      regions_array << (region + num_cols)
      regions_array << (region + 1)
    end

    # upper left corner (always sector 0)
    if (regions_array.length == 0) && (region == 0)
      regions_array << (num_rows * num_cols - 1)
      regions_array << first_value_in_last_row
      regions_array << first_value_in_last_row + 1
      regions_array << (num_cols - 1)
      regions_array << 1
      regions_array << (num_cols + num_cols - 1)
      regions_array << (num_cols)
      regions_array << (num_cols + 1)
    end

    # upper right corner
    if (regions_array.length == 0) && PostsHelper.IsRightEdge(region, fraction) && PostsHelper.IsTopRow(region, fraction)
      regions_array << (num_rows * num_cols - 2)
      regions_array << last_value_in_last_row
      regions_array << first_value_in_last_row
      regions_array << (region - 1)
      regions_array << 0
      regions_array << (region + num_cols - 1)
      regions_array << (region + num_cols)
      regions_array << num_cols
    end

    # lower left corner (is firstValueInLastRow)
    if (regions_array.length == 0) && PostsHelper.IsLeftEdge(region, fraction) && PostsHelper.IsBottomRow(region, fraction)
      regions_array << (last_value_in_last_row - num_cols)
      regions_array << (region - num_cols)
      regions_array << (region - num_cols + 1)
      regions_array << last_value_in_last_row
      regions_array << (region + 1)
      regions_array << (num_cols - 1)
      regions_array << 0
      regions_array << 1
    end

    # lower right corner (is lastValueInLastRow)
    if (regions_array.length == 0) && PostsHelper.IsRightEdge(region, fraction) && PostsHelper.IsBottomRow(region, fraction)
      regions_array << (region - num_cols - 1)
      regions_array << (region - num_cols)
      regions_array << (first_value_in_last_row - num_cols)
      regions_array << (region - 1)
      regions_array << first_value_in_last_row
      regions_array << (num_cols - 2)
      regions_array << (num_cols - 1)
      regions_array << 0
    end

    # return regions_array
    regions_array
  end

  def PostsHelper.IsLeftEdge(region, fraction)
    num_cols = ((1.0 / fraction) * 360).round(0)
    div = (region % num_cols)
    (div == 0)
  end

  def PostsHelper.IsRightEdge(region, fraction)
    PostsHelper.IsLeftEdge(region + 1, fraction)
  end

  def PostsHelper.IsTopRow(region, fraction)
    num_cols = ((1.0 / fraction) * 360).round(0)
    (region >= 0 && (region <= (num_cols - 1)))
  end

  def PostsHelper.IsBottomRow(region, fraction)
    num_cols = ((1.0 / fraction) * 360).round(0)
    num_rows = ((1.0 / fraction) * 180).round(0)
    first_value_in_last_row = num_cols * (num_rows - 1)
    last_value_in_last_row = (num_cols * num_rows) - 1
    (region >= first_value_in_last_row) && (region <= last_value_in_last_row)
  end
end
