class ItemInfo < ActiveRecord::Base
  validates :tier, :presence => true
  validates :price, :presence => true
  validates :supplymax, :presence => true
  validates :supplyrate, :presence => true
  validates :multiplier, :presence => true

  has_many :item_locs, :dependent => :destroy
end
