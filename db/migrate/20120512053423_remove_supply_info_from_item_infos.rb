class RemoveSupplyInfoFromItemInfos < ActiveRecord::Migration
  def up
    remove_column :item_infos, :supplymax_1
        remove_column :item_infos, :supplyrate_1
        remove_column :item_infos, :supplymax_2
        remove_column :item_infos, :supplyrate_2
        remove_column :item_infos, :supplymax_3
        remove_column :item_infos, :supplyrate_3
      end

  def down
    add_column :item_infos, :supplyrate_3, :integer
    add_column :item_infos, :supplymax_3, :integer
    add_column :item_infos, :supplyrate_2, :integer
    add_column :item_infos, :supplymax_2, :integer
    add_column :item_infos, :supplyrate_1, :integer
    add_column :item_infos, :supplymax_1, :integer
  end
end
