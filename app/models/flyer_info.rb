class FlyerInfo < ActiveRecord::Base
  has_many :flyer_locs, :dependent => :destroy
end
