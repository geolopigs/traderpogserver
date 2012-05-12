class AddSupplyInfoToItemInfos < ActiveRecord::Migration
  def change
    add_column :item_infos, :supplymax, :integer

    add_column :item_infos, :supplyrate, :integer

    add_column :item_infos, :multiplier, :integer

  end
end
