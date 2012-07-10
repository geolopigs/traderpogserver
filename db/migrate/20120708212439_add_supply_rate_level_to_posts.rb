class AddSupplyRateLevelToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :supplyratelevel, :integer
  end
end
