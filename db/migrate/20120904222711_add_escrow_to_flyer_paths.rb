class AddEscrowToFlyerPaths < ActiveRecord::Migration
  def change
    add_column :flyer_paths, :item_info_id, :integer

    add_column :flyer_paths, :num_items, :integer

    add_column :flyer_paths, :price, :integer

  end
end
