module FlyerInfosHelper

  def FlyerInfosHelper.getflyerloc(flyer_info, language)
    flyer_loc_array = flyer_info.flyer_locs.where("locale = ?", language).select("locale, localized_name, localized_desc")
    if flyer_loc_array.empty?
      # There is no corresponding item_loc for this item_info. Fake one for now to prevent failure.
      flyer_loc = ItemLoc.new
      flyer_loc_array = [ flyer_loc ]
    end
    flyer_loc_array
  end

end
