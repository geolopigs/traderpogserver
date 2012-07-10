class AddSupplyMaxLevelToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :supplymaxlevel, :integer
  end
end
