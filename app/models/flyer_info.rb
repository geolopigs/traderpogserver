class FlyerInfo < ActiveRecord::Base
  has_many :flyer_locs, :dependent => :destroy

  validates :capacity, :presence => true
  validates :speed, :presence => true
  validates :stormresist, :presence => true
  validates :multiplier, :presence => true
  validates :price, :presence => true
  validates :tier, :presence => true
  validates :load_time, :presence => true
end
