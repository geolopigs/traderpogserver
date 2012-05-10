class PostItem < ActiveRecord::Base
  belongs_to :post
  belongs_to :item_info
end
