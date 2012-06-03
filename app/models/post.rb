class Post < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  has_many :post_items, :dependent => :destroy
  has_many :item_infos, :through => :post_items
  has_many :beacons, :dependent => :destroy
end
