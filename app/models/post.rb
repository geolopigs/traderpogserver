class Post < ActiveRecord::Base
  validates :latitude, :presence => true
  validates :longitude, :presence => true
  validates :user_id, :presence => true
  validates :item_info_id, :presence => true
  validates :supplymaxlevel, :presence => true
  validates :supplyratelevel, :presence => true

  belongs_to :user
  belongs_to :item_info
end
