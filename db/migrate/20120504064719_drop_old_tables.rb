class DropOldTables < ActiveRecord::Migration
  def up
    drop_table :item_bases
    drop_table :item_locs
    drop_table :post_items
  end

  def down
  end
end
