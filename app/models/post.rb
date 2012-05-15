class Post < ActiveRecord::Base
  has_many :post_items, :dependent => :destroy
  has_many :item_infos, :through => :post_items
end
