class ItemInfo < ActiveRecord::Base
  has_many :item_locs, :dependent => :destroy
  has_many :post_items, :dependent => :destroy
  has_many :posts, :through => :post_items
end
