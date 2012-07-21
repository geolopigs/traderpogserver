class UserFlyer < ActiveRecord::Base
  belongs_to :user
  belongs_to :flyer_info
end
