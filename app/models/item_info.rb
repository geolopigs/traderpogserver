class ItemInfo < ActiveRecord::Base
  has_many :item_locs
  has_many :posts, :through => :post_items
end
