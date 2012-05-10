class CreateItemInfos < ActiveRecord::Migration
  def change
    create_table :item_infos do |t|
      t.integer :price
      t.integer :supplymax_1
      t.integer :supplyrate_1
      t.integer :supplymax_2
      t.integer :supplyrate_2
      t.integer :supplymax_3
      t.integer :supplyrate_3

      t.timestamps
    end
  end
end
