class ItemInfo < ActiveRecord::Base
  has_many :item_locs, :dependent => :destroy
end
