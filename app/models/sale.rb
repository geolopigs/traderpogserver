class Sale < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates :amount, :presence => true
end
