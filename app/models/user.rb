class User < ActiveRecord::Base
  has_many :posts, :dependent => :destroy
  has_many :beacons
  has_many :userconfigs, :dependent => :destroy
  has_many :user_flyers, :dependent => :destroy

  validates :secretkey, :presence => true
end
