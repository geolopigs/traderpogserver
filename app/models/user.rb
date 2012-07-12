class User < ActiveRecord::Base
  has_many :posts, :dependent => :destroy
  has_many :beacons
  has_many :userconfigs, :dependent => :destroy

  validates :secretkey, :presence => true
end
