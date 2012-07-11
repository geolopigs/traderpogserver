class AddTierToItemInfo < ActiveRecord::Migration
  def change
    add_column :item_infos, :tier, :integer
  end
end
